-- BigQuery Standard SQL
-- Normalize strings and safely convert usable 0-5 ratings, including half-points.

CREATE OR REPLACE TABLE `YOUR_PROJECT_ID.credit_card_analysis.cleaned_reviews` AS
WITH normalized AS (
  SELECT
    TRIM(card_name) AS card_name,
    NULLIF(TRIM(category), '') AS category,
    NULLIF(TRIM(date_reviewed), '') AS date_reviewed_raw,
    SAFE.PARSE_DATE('%b %d, %Y', TRIM(date_reviewed)) AS reviewed_date,
    NULLIF(TRIM(profile_type), '') AS profile_type,
    SAFE_CAST(NULLIF(TRIM(ratings), '') AS FLOAT64) AS parsed_rating,
    NULLIF(TRIM(review_text), '') AS review_text,
    NULLIF(TRIM(source), '') AS source,
    NULLIF(TRIM(bank_name), '') AS bank_name,
    NULLIF(TRIM(old_new), '') AS old_new
  FROM `YOUR_PROJECT_ID.credit_card_analysis.raw_reviews`
)
SELECT
  card_name,
  category,
  date_reviewed_raw,
  reviewed_date,
  profile_type,
  IF(parsed_rating BETWEEN 0 AND 5, parsed_rating, NULL) AS rating_numeric,
  review_text,
  source,
  bank_name,
  old_new
FROM normalized
WHERE card_name IS NOT NULL
  AND card_name != '';
