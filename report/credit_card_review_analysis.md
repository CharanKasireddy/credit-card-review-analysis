# Credit Card Review Analysis with Google BigQuery

## Executive summary

This case study uses Google BigQuery Standard SQL to analyze 7,513 public credit-card review records covering 59 cards. Because only 1,616 rows contain numeric ratings, the analysis keeps review volume separate from rating quality and requires at least 20 numeric ratings for ranking eligibility.

The highest Bayesian-adjusted review score belongs to **Axis Bank Myzone Credit card**. **SBI Card ELITE** is the most reviewed card among the top five and also leads welcome offers and overall lifestyle benefits. **ICICI Bank Coral** provides the strongest annual-fee and waiver combination, **Flipkart Axis Bank** leads shopping rewards, and **Axis Bank Horizon** offers the strongest current travel package with the important caveat that its terms are mapped to the legacy Citi PremierMiles review record.

## Ask

The analysis addresses two business questions:

1. Which reviewed cards perform best after accounting for rating sample size?
2. Which current products lead borrowing cost, annual fee, welcome bonus, rewards, and benefits?

## Prepare

The source is the public Kaggle Credit Card Reviews dataset. The BigQuery-loadable CSV contains nine fields: card name, category, date reviewed, profile type, rating, review text, source, bank name, and old/new label.

The data is India-specific and no later than 2020. It is a self-selected review sample and is not a measure of market share.

## Process

The source CSV was loaded into BigQuery with an explicit schema and quoted-newline support. Standard SQL then:

- trimmed text values;
- safely parsed dates;
- converted valid 0–5 ratings, including half-points, with `SAFE_CAST`;
- retained missing and nonnumeric ratings as `NULL`; and
- separated total review count from numeric-rating count.

BigQuery assertions confirm 7,513 clean rows, 59 distinct cards, 1,616 numeric ratings, and a global mean of 3.237005.

## Analyze

A card must have at least 20 numeric ratings to qualify. Eligible cards are ranked with:

```text
Weighted score = (n × card mean + 20 × global mean) ÷ (n + 20)
```

| Rank | Card | Reviews | Numeric ratings | Average | Bayesian score |
|---:|---|---:|---:|---:|---:|
| 1 | Axis Bank Myzone Credit card | 75 | 20 | 4.700 | 3.968502 |
| 2 | ICICI CORAL VISA CONTACTLESS | 20 | 20 | 4.525 | 3.881002 |
| 3 | SBI ELITE | 124 | 20 | 4.500 | 3.868502 |
| 4 | CITIBANK PREMIERMILES | 20 | 20 | 4.450 | 3.843502 |
| 5 | AXIS FLIPKART | 85 | 20 | 4.425 | 3.831002 |

The Bayesian adjustment preserves the same top-five order while reducing overconfidence in small rating samples.

## Share

### Review performance

- Axis Bank My Zone has the highest eligible average rating.
- SBI Card ELITE has the greatest review volume among the top five.
- All five leaders have exactly 20 numeric ratings, so their adjusted order is primarily driven by average rating.

### Current product comparison

- **Borrowing cost:** five-way tie at a published 3.75% monthly finance charge, approximately 55.55% effective annualized.
- **Annual fee and waiver:** ICICI Bank Coral, with a ₹500 annual fee waived at ₹1.5 lakh annual spend.
- **Welcome offer:** SBI Card ELITE, with a ₹5,000 e-gift voucher.
- **Shopping rewards:** Flipkart Axis Bank, with high explicit partner cashback rates.
- **Lifestyle benefits:** SBI Card ELITE, combining welcome value, movies, accelerated rewards, and milestones.
- **Travel benefits:** Axis Bank Horizon, the current migrated successor mapped to legacy Citi PremierMiles reviews.

## Act

For consumers prioritizing review quality, Axis Bank My Zone is the strongest result in this sample. Consumers prioritizing a lower-fee card should compare ICICI Coral's waiver against their expected annual spend. High-spend lifestyle users may receive more value from SBI ELITE, shopping-focused users from Flipkart Axis Bank, and frequent travelers from Axis Horizon.

Before applying, consumers should verify current issuer pages because fees, promotions, eligibility rules, reward caps, and taxes can change.

## Limitations

- Numeric ratings appear on only 21.5% of review rows.
- Reviews are self-selected, India-specific, and historical.
- Review volume is not customer count or market share.
- Current product terms are manually verified inputs and remain time-sensitive.
- Citi PremierMiles review performance cannot be treated as review evidence for Axis Horizon.
- The analysis is descriptive and does not establish causation.

## Reproducibility

The complete workflow is in `sql/`. `06_validate.sql` contains executable BigQuery assertions for the key counts and top-five order. The `data/processed/` CSV files and `analysis/credit_card_review_analysis.xlsx` workbook are presentation outputs from the validated BigQuery tables.
