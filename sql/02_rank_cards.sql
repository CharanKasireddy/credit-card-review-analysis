-- BigQuery Standard SQL
-- Rank cards using a 20-rating eligibility threshold and Bayesian shrinkage.

DECLARE minimum_numeric_ratings INT64 DEFAULT 20;
DECLARE prior_weight FLOAT64 DEFAULT 20.0;

CREATE OR REPLACE TABLE `YOUR_PROJECT_ID.credit_card_analysis.card_ranking` AS
WITH global_stats AS (
  SELECT AVG(rating_numeric) AS global_mean_rating
  FROM `YOUR_PROJECT_ID.credit_card_analysis.cleaned_reviews`
  WHERE rating_numeric IS NOT NULL
),
card_stats AS (
  SELECT
    card_name,
    ANY_VALUE(category) AS category,
    ANY_VALUE(bank_name) AS bank,
    COUNT(*) AS total_reviews,
    COUNT(rating_numeric) AS numeric_ratings,
    AVG(rating_numeric) AS average_rating
  FROM `YOUR_PROJECT_ID.credit_card_analysis.cleaned_reviews`
  GROUP BY card_name
),
scored AS (
  SELECT
    card_stats.*,
    SAFE_DIVIDE(
      numeric_ratings * average_rating + prior_weight * global_mean_rating,
      numeric_ratings + prior_weight
    ) AS bayesian_score,
    numeric_ratings >= minimum_numeric_ratings AS eligible
  FROM card_stats
  CROSS JOIN global_stats
),
eligible_ranked AS (
  SELECT
    card_name,
    ROW_NUMBER() OVER (
      ORDER BY bayesian_score DESC, average_rating DESC, total_reviews DESC, card_name
    ) AS eligible_rank
  FROM scored
  WHERE eligible
)
SELECT
  scored.card_name,
  scored.category,
  scored.bank,
  scored.total_reviews,
  scored.numeric_ratings,
  scored.average_rating,
  scored.bayesian_score,
  scored.eligible,
  eligible_ranked.eligible_rank
FROM scored
LEFT JOIN eligible_ranked USING (card_name);
