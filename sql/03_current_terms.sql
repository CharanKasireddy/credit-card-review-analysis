-- BigQuery Standard SQL
-- Current issuer inputs verified from official product pages on 2026-08-15.

CREATE OR REPLACE TABLE `YOUR_PROJECT_ID.credit_card_analysis.current_terms` AS
SELECT *
FROM UNNEST([
  STRUCT(
    1 AS review_rank,
    'Axis Bank Myzone Credit card' AS reviewed_card,
    'Axis Bank My Zone' AS current_product,
    'Current' AS product_status,
    0.0375 AS monthly_finance_charge,
    POW(1 + 0.0375, 12) - 1 AS effective_annualized_rate,
    500 AS annual_fee_inr,
    CAST(NULL AS INT64) AS fee_waiver_spend_inr,
    'SonyLIV annual subscription valued at ₹1,499' AS welcome_offer,
    '4 EDGE points per ₹200 plus 1,000 milestone points at ₹1.5 lakh annual spend' AS rewards_summary,
    'SonyLIV; District BOGO; Swiggy discount; conditional domestic lounge; fuel waiver' AS benefits_summary,
    'https://www.axis.bank.in/cards/credit-card/axis-bank-my-zone-credit-card' AS source_url
  ),
  STRUCT(
    2,
    'ICICI CORAL VISA CONTACTLESS',
    'ICICI Bank Coral',
    'Current',
    0.0375,
    POW(1 + 0.0375, 12) - 1,
    500,
    150000,
    'No separate welcome gift listed',
    '2 points per ₹100 retail and 1 point per ₹100 utility or insurance',
    'Conditional lounge; movies; railway lounge; fuel waiver',
    'https://www.icici.bank.in/personal-banking/cards/credit-card/coral-credit-card'
  ),
  STRUCT(
    3,
    'SBI ELITE',
    'SBI Card ELITE',
    'Current',
    0.0375,
    POW(1 + 0.0375, 12) - 1,
    4999,
    1000000,
    '₹5,000 e-gift voucher',
    '5X points on dining, department stores, and grocery plus milestone rewards',
    'Movie tickets and premium lifestyle benefits',
    'https://www.sbicard.com/en/personal/credit-cards/sbi-card-elite.html'
  ),
  STRUCT(
    4,
    'CITIBANK PREMIERMILES',
    'Axis Bank Horizon',
    'Legacy card migrated',
    0.0375,
    POW(1 + 0.0375, 12) - 1,
    3000,
    CAST(NULL AS INT64),
    '5,000 EDGE Miles',
    '5 EDGE Miles per ₹100 on Travel EDGE or direct airlines and 2 elsewhere',
    'Domestic and international lounges; fuel waiver; lost-card liability cover',
    'https://www.axis.bank.in/cards/credit-card/axis-horizon-credit-card'
  ),
  STRUCT(
    5,
    'AXIS FLIPKART',
    'Flipkart Axis Bank',
    'Current',
    0.0375,
    POW(1 + 0.0375, 12) - 1,
    500,
    350000,
    'Current activation value starts at ₹100',
    '7.5% Myntra; 5% Flipkart and Cleartrip; 4% preferred merchants; 1% eligible other spend',
    'Limited-period nil joining fee; fuel waiver',
    'https://www.axis.bank.in/cards/credit-card/flipkart-axisbank-credit-card'
  )
]);
