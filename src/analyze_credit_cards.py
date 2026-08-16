"""Reproduce the credit-card review ranking used in this project."""

from __future__ import annotations

import argparse
from pathlib import Path

import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_INPUT = ROOT / "data" / "raw" / "All_Reviews.xlsx"
DEFAULT_OUTPUT = ROOT / "data" / "processed"
MINIMUM_RATINGS = 20
PRIOR_WEIGHT = 20


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT)
    return parser.parse_args()


def first_nonempty(series: pd.Series) -> str:
    values = series.dropna().astype(str).str.strip()
    values = values[values.ne("")]
    return values.iloc[0] if not values.empty else ""


def build_ranking(review_data: pd.DataFrame) -> tuple[pd.DataFrame, float]:
    required = {"Card Name", "Category", "Ratings", "Bank Name"}
    missing = required.difference(review_data.columns)
    if missing:
        raise ValueError(f"Missing required columns: {sorted(missing)}")

    clean = review_data.copy()
    clean["Card Name"] = clean["Card Name"].astype("string").str.strip()
    clean = clean[clean["Card Name"].notna() & clean["Card Name"].ne("")]
    clean["rating_numeric"] = pd.to_numeric(clean["Ratings"], errors="coerce")

    global_mean = clean["rating_numeric"].mean()
    ranking = (
        clean.groupby("Card Name", as_index=False)
        .agg(
            category=("Category", first_nonempty),
            bank=("Bank Name", first_nonempty),
            total_reviews=("Card Name", "size"),
            numeric_ratings=("rating_numeric", "count"),
            average_rating=("rating_numeric", "mean"),
        )
    )

    n = ranking["numeric_ratings"]
    ranking["bayesian_score"] = (
        n * ranking["average_rating"] + PRIOR_WEIGHT * global_mean
    ) / (n + PRIOR_WEIGHT)
    ranking.loc[n.eq(0), "bayesian_score"] = pd.NA
    ranking["eligible"] = n.ge(MINIMUM_RATINGS)

    eligible = ranking.loc[ranking["eligible"]].copy()
    eligible["eligible_rank"] = (
        eligible["bayesian_score"].rank(method="min", ascending=False).astype("Int64")
    )
    ranking = ranking.merge(
        eligible[["Card Name", "eligible_rank"]], on="Card Name", how="left"
    )
    ranking = ranking.sort_values(
        ["eligible", "bayesian_score", "total_reviews", "Card Name"],
        ascending=[False, False, False, True],
        na_position="last",
    ).reset_index(drop=True)
    return ranking, float(global_mean)


def main() -> None:
    args = parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)

    reviews = pd.read_excel(args.input, sheet_name="All Reviews")
    ranking, global_mean = build_ranking(reviews)
    top_five = ranking.loc[ranking["eligible"]].head(5).copy()

    ranking.to_csv(args.output_dir / "card_ranking.csv", index=False)
    top_five.to_csv(args.output_dir / "top_five_credit_cards.csv", index=False)

    print(f"Review rows: {len(reviews):,}")
    print(f"Unique cards: {ranking['Card Name'].nunique():,}")
    print(f"Numeric ratings: {int(ranking['numeric_ratings'].sum()):,}")
    print(f"Global mean: {global_mean:.3f}")
    print("Top five:")
    for row in top_five.itertuples(index=False):
        print(
            f"  {int(row.eligible_rank)}. {getattr(row, '_0', row[0])} — "
            f"{row.average_rating:.3f} average; {row.total_reviews} reviews"
        )


if __name__ == "__main__":
    main()
