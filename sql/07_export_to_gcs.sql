-- BigQuery Standard SQL
-- Optional: export result tables to Cloud Storage as CSV files.
-- Replace YOUR_PROJECT_ID and YOUR_BUCKET before running.

EXPORT DATA OPTIONS (
  uri = 'gs://YOUR_BUCKET/exports/card_ranking-*.csv',
  format = 'CSV',
  overwrite = TRUE,
  header = TRUE
) AS
SELECT *
FROM `YOUR_PROJECT_ID.credit_card_analysis.card_ranking`
ORDER BY eligible DESC, eligible_rank, bayesian_score DESC;

EXPORT DATA OPTIONS (
  uri = 'gs://YOUR_BUCKET/exports/top_five_credit_cards-*.csv',
  format = 'CSV',
  overwrite = TRUE,
  header = TRUE
) AS
SELECT *
FROM `YOUR_PROJECT_ID.credit_card_analysis.top_five_credit_cards`;

EXPORT DATA OPTIONS (
  uri = 'gs://YOUR_BUCKET/exports/current_terms-*.csv',
  format = 'CSV',
  overwrite = TRUE,
  header = TRUE
) AS
SELECT *
FROM `YOUR_PROJECT_ID.credit_card_analysis.current_terms`
ORDER BY review_rank;

EXPORT DATA OPTIONS (
  uri = 'gs://YOUR_BUCKET/exports/category_leaders-*.csv',
  format = 'CSV',
  overwrite = TRUE,
  header = TRUE
) AS
SELECT *
FROM `YOUR_PROJECT_ID.credit_card_analysis.category_leaders`
ORDER BY display_order;
