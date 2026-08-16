# Credit Card Review Analysis with Google BigQuery

An end-to-end SQL analytics project that combines 7,513 public credit-card review records with current issuer pricing, welcome offers, rewards, and benefits. All data cleaning, aggregation, scoring, ranking, validation, and output generation is implemented in **Google BigQuery Standard SQL**.

The project answers two questions:

1. Which cards received the strongest eligible consumer-review scores in the dataset?
2. Which of those cards currently leads borrowing cost, annual fee, welcome offer, shopping rewards, lifestyle benefits, or travel benefits?

![BigQuery credit card analysis dashboard](images/dashboard.png)

## Project highlights

- Analyzed **7,513 reviews** covering **59 credit cards** in BigQuery.
- Retained **1,616 usable numeric ratings** on the source's 0–5 scale, including half-point ratings.
- Required at least **20 numeric ratings** before a card could enter the top five.
- Used a Bayesian-adjusted score to reduce the influence of small samples.
- Added BigQuery `ASSERT` checks for row count, distinct cards, rating count, global mean, and top-five order.
- Verified current product terms using official Axis Bank, ICICI Bank, and SBI Card pages.
- Packaged the BigQuery results in a charted Excel workbook and a written case-study report.

## Top five reviewed cards

| Rank | Reviewed card | Total reviews | Numeric ratings | Average rating | Bayesian score |
|---:|---|---:|---:|---:|---:|
| 1 | Axis Bank Myzone Credit card | 75 | 20 | 4.700 | 3.968502 |
| 2 | ICICI CORAL VISA CONTACTLESS | 20 | 20 | 4.525 | 3.881002 |
| 3 | SBI ELITE | 124 | 20 | 4.500 | 3.868502 |
| 4 | CITIBANK PREMIERMILES | 20 | 20 | 4.450 | 3.843502 |
| 5 | AXIS FLIPKART | 85 | 20 | 4.425 | 3.831002 |

## Category leaders

| Category | Leader | Reason |
|---|---|---|
| Highest review rating | Axis Bank My Zone | 4.70 average from 20 numeric ratings |
| Most reviewed among the top five | SBI Card ELITE | 124 review rows |
| Lowest borrowing cost | Five-way tie | Each current product lists a 3.75% monthly finance charge |
| Best ongoing fee and waiver | ICICI Bank Coral | ₹500 annual fee, waived at ₹1.5 lakh annual spend |
| Best welcome offer | SBI Card ELITE | ₹5,000 e-gift voucher |
| Best shopping rewards | Flipkart Axis Bank | Strong explicit partner cashback rates |
| Broadest lifestyle benefits | SBI Card ELITE | Welcome voucher, movies, accelerated rewards, and milestones |
| Best travel package | Axis Bank Horizon | Travel miles and lounge access; successor caveat applies |

> **Legacy-product note:** the review score belongs to Citi PremierMiles. Current pricing and travel benefits are shown for Axis Horizon, the migrated successor, and are not historical Citi terms.

## BigQuery methodology

Cards are grouped by exact card name. The ranking query calculates total reviews, usable numeric-rating count, average rating, and a Bayesian-adjusted score:

```text
Weighted score = (n × card mean + 20 × global mean) ÷ (n + 20)
```

The global numeric-rating mean is 3.237005. Only cards with at least 20 numeric ratings are eligible.

Issuer pages publish a monthly finance charge rather than a U.S.-style APR. BigQuery normalizes this with:

```text
Effective annualized rate = (1 + monthly finance charge)^12 − 1
```

A 3.75% monthly finance charge equals approximately 55.55% effective annualized.

See [docs/METHODOLOGY.md](docs/METHODOLOGY.md) for the complete process and limitations.

## Repository contents

```text
credit-card-review-analysis/
├── analysis/
│   └── credit_card_review_analysis.xlsx
├── data/
│   ├── raw/
│   │   ├── All_Reviews.csv
│   │   └── All_Reviews.xlsx
│   └── processed/
│       ├── analysis_summary.csv
│       ├── card_ranking.csv
│       ├── category_leaders.csv
│       ├── current_terms.csv
│       └── top_five_credit_cards.csv
├── docs/
│   ├── DATA_DICTIONARY.md
│   ├── METHODOLOGY.md
│   └── SOURCES.md
├── images/
│   ├── dashboard.png
│   ├── fee_welcome_chart.png
│   ├── rating_chart.png
│   └── review_count_chart.png
├── report/
│   └── credit_card_review_analysis.md
├── sql/
│   ├── 00_setup_and_load.sql
│   ├── 01_clean_reviews.sql
│   ├── 02_rank_cards.sql
│   ├── 03_current_terms.sql
│   ├── 04_category_leaders.sql
│   ├── 05_create_outputs.sql
│   ├── 06_validate.sql
│   ├── 07_export_to_gcs.sql
│   └── README.md
├── CITATION.cff
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

## Reproduce in BigQuery

1. Upload `data/raw/All_Reviews.csv` to a Google Cloud Storage bucket.
2. Replace `YOUR_PROJECT_ID` and `YOUR_BUCKET` in the SQL files.
3. Run [sql/00_setup_and_load.sql](sql/00_setup_and_load.sql) through [sql/06_validate.sql](sql/06_validate.sql) in numeric order in the BigQuery console.
4. Optionally run [sql/07_export_to_gcs.sql](sql/07_export_to_gcs.sql) to export the result tables.

The scripts use BigQuery Standard SQL only. The source-load statement supports quoted newlines in review text, and the cleaning query uses `SAFE_CAST` so nonnumeric ratings become `NULL` instead of failing the pipeline.

## Deliverables

- [BigQuery SQL pipeline](sql/README.md)
- [Excel analysis workbook](analysis/credit_card_review_analysis.xlsx)
- [Case-study report](report/credit_card_review_analysis.md)
- [Methodology](docs/METHODOLOGY.md)
- [Data dictionary](docs/DATA_DICTIONARY.md)
- [Primary sources](docs/SOURCES.md)

## Limitations

- The reviews are India-specific, self-selected, and published no later than 2020.
- Only 21.5% of review rows contain numeric ratings.
- Review volume is not the same as cardholder count or market share.
- Current issuer offers, caps, taxes, eligibility rules, and fees can change.
- Results are directional and should not be interpreted as causal or representative of the full market.

## Data license and attribution

The review data comes from the public [Credit Card Reviews dataset on Kaggle](https://www.kaggle.com/datasets/arjunanc/credit-card-reviews), published by Arjun N C under CC0. Current product terms are attributed to official issuer pages in [docs/SOURCES.md](docs/SOURCES.md).

Project SQL and original documentation are available under the [MIT License](LICENSE).
