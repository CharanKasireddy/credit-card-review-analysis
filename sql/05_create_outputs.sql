-- BigQuery Standard SQL

CREATE OR REPLACE VIEW `YOUR_PROJECT_ID.credit_card_analysis.top_five_credit_cards` AS
SELECT *
FROM `YOUR_PROJECT_ID.credit_card_analysis.card_ranking`
WHERE eligible_rank BETWEEN 1 AND 5
ORDER BY eligible_rank;

CREATE OR REPLACE VIEW `YOUR_PROJECT_ID.credit_card_analysis.analysis_summary` AS
SELECT
  COUNT(*) AS review_rows,
  COUNT(DISTINCT card_name) AS distinct_cards,
  COUNT(rating_numeric) AS numeric_ratings,
  SAFE_DIVIDE(COUNT(rating_numeric), COUNT(*)) AS rating_coverage,
  AVG(rating_numeric) AS global_mean_rating
FROM `YOUR_PROJECT_ID.credit_card_analysis.cleaned_reviews`;

CREATE OR REPLACE VIEW `YOUR_PROJECT_ID.credit_card_analysis.dashboard_export` AS
SELECT
  ranking.eligible_rank AS review_rank,
  ranking.card_name AS reviewed_card,
  terms.current_product,
  ranking.total_reviews,
  ranking.numeric_ratings,
  ranking.average_rating,
  ranking.bayesian_score,
  terms.monthly_finance_charge,
  terms.effective_annualized_rate,
  terms.annual_fee_inr,
  terms.fee_waiver_spend_inr,
  terms.welcome_offer,
  terms.rewards_summary,
  terms.benefits_summary,
  terms.source_url
FROM `YOUR_PROJECT_ID.credit_card_analysis.top_five_credit_cards` AS ranking
JOIN `YOUR_PROJECT_ID.credit_card_analysis.current_terms` AS terms
  ON ranking.eligible_rank = terms.review_rank
ORDER BY review_rank;
