-- BigQuery Standard SQL

CREATE OR REPLACE TABLE `YOUR_PROJECT_ID.credit_card_analysis.category_leaders` AS
SELECT *
FROM UNNEST([
  STRUCT(1 AS display_order, 'Highest review rating' AS category, 'Axis Bank My Zone' AS leader, '4.70 average from 20 numeric ratings' AS reason),
  STRUCT(2, 'Most reviewed among the top five', 'SBI Card ELITE', '124 review rows'),
  STRUCT(3, 'Lowest borrowing cost', 'Five-way tie', 'Each current product lists a 3.75% monthly finance charge'),
  STRUCT(4, 'Best ongoing fee and waiver', 'ICICI Bank Coral', '₹500 annual fee, waived at ₹1.5 lakh annual spend'),
  STRUCT(5, 'Best welcome offer', 'SBI Card ELITE', '₹5,000 e-gift voucher'),
  STRUCT(6, 'Best shopping rewards', 'Flipkart Axis Bank', 'Strong explicit partner cashback rates'),
  STRUCT(7, 'Broadest lifestyle benefits', 'SBI Card ELITE', 'Welcome voucher, movies, accelerated rewards, and milestones'),
  STRUCT(8, 'Best travel package', 'Axis Bank Horizon', 'Travel miles and lounge access; successor caveat applies')
]);
