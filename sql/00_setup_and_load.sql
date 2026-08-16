-- BigQuery Standard SQL
-- Replace YOUR_PROJECT_ID and YOUR_BUCKET before running.

CREATE SCHEMA IF NOT EXISTS `YOUR_PROJECT_ID.credit_card_analysis`
OPTIONS (
  location = 'US',
  description = 'Credit card review and current product terms analysis'
);

LOAD DATA OVERWRITE `YOUR_PROJECT_ID.credit_card_analysis.raw_reviews` (
  card_name STRING,
  category STRING,
  date_reviewed STRING,
  profile_type STRING,
  ratings STRING,
  review_text STRING,
  source STRING,
  bank_name STRING,
  old_new STRING
)
FROM FILES (
  format = 'CSV',
  uris = ['gs://YOUR_BUCKET/All_Reviews.csv'],
  skip_leading_rows = 1,
  allow_quoted_newlines = TRUE,
  encoding = 'UTF-8'
);
