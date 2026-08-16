# Data dictionary

## `raw_reviews`

| Field | BigQuery type | Description |
|---|---|---|
| `card_name` | STRING | Card name as published in the review dataset |
| `category` | STRING | Dataset card category |
| `date_reviewed` | STRING | Raw review date text |
| `profile_type` | STRING | Reviewer profile label |
| `ratings` | STRING | Raw rating value, including `None` |
| `review_text` | STRING | Consumer review text |
| `source` | STRING | Review-source label |
| `bank_name` | STRING | Issuer name in the dataset |
| `old_new` | STRING | Dataset legacy/current label |

## `cleaned_reviews`

Adds `reviewed_date` as `DATE` where parsing succeeds and `rating_numeric` as `FLOAT64` for usable 0–5 ratings. Other fields are trimmed and empty strings are converted to `NULL`.

## `card_ranking`

| Field | BigQuery type | Description |
|---|---|---|
| `total_reviews` | INT64 | All review rows for the card |
| `numeric_ratings` | INT64 | Rows with usable numeric ratings |
| `average_rating` | FLOAT64 | Mean numeric rating |
| `bayesian_score` | FLOAT64 | Rating adjusted toward the global mean with a prior weight of 20 |
| `eligible` | BOOL | Whether the card has at least 20 numeric ratings |
| `eligible_rank` | INT64 | Rank among eligible cards; `NULL` for ineligible cards |

## `current_terms`

Contains the reviewed product, current product mapping, status, monthly finance charge, effective annualized rate, annual fee, waiver threshold, welcome offer, rewards, benefits, and official source URL.

## Output views

- `top_five_credit_cards`: eligible ranks 1–5
- `analysis_summary`: dataset-level counts, coverage, and mean rating
- `dashboard_export`: joined review ranking and current-term comparison
