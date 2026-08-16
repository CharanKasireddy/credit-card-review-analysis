-- BigQuery Standard SQL
-- These assertions stop the script if source counts or expected ranking results change.

ASSERT (
  SELECT COUNT(*) = 7513
  FROM `YOUR_PROJECT_ID.credit_card_analysis.cleaned_reviews`
) AS 'Expected 7,513 cleaned review rows.';

ASSERT (
  SELECT COUNT(DISTINCT card_name) = 59
  FROM `YOUR_PROJECT_ID.credit_card_analysis.cleaned_reviews`
) AS 'Expected 59 distinct cards.';

ASSERT (
  SELECT COUNT(rating_numeric) = 1616
  FROM `YOUR_PROJECT_ID.credit_card_analysis.cleaned_reviews`
) AS 'Expected 1,616 usable numeric ratings.';

ASSERT (
  SELECT ABS(AVG(rating_numeric) - 3.2370049504950495) < 0.000000001
  FROM `YOUR_PROJECT_ID.credit_card_analysis.cleaned_reviews`
) AS 'Global mean rating does not match the validated result.';

ASSERT (
  SELECT ARRAY_TO_STRING(ARRAY_AGG(card_name ORDER BY eligible_rank), '|') =
    'Axis Bank Myzone Credit card|ICICI CORAL VISA CONTACTLESS|SBI ELITE|CITIBANK PREMIERMILES|AXIS FLIPKART'
  FROM `YOUR_PROJECT_ID.credit_card_analysis.top_five_credit_cards`
) AS 'Top-five card order does not match the validated result.';

SELECT
  'PASS' AS validation_status,
  summary.*
FROM `YOUR_PROJECT_ID.credit_card_analysis.analysis_summary` AS summary;
