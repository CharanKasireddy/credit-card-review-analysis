# Data

## Raw data

- `raw/All_Reviews.xlsx` is the original workbook from the public Kaggle [Credit Card Reviews](https://www.kaggle.com/datasets/arjunanc/credit-card-reviews) dataset.
- `raw/All_Reviews.csv` is the UTF-8, BigQuery-loadable copy used by the SQL pipeline. It preserves quoted commas and quoted newlines in review text.

The dataset is published under CC0.

## BigQuery-generated outputs

- `processed/analysis_summary.csv` contains the validated dataset-level metrics.
- `processed/card_ranking.csv` contains review metrics and eligibility results for all 59 cards.
- `processed/top_five_credit_cards.csv` contains the five highest Bayesian scores among eligible cards.
- `processed/current_terms.csv` contains manually verified current issuer inputs created by BigQuery SQL.
- `processed/category_leaders.csv` contains the final category winners and reasoning.

The processed files are exports of tables or views created by the scripts in `sql/`. Current terms are time-sensitive and should be verified again before use.
