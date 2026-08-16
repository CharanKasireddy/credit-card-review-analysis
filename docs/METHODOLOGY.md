# Methodology

## 1. Define the business question

The project identifies the strongest reviewed cards in the dataset and then determines which current product leads borrowing cost, annual fee, welcome offer, rewards, or overall benefits.

Review performance and current product value are analyzed separately because the review data was published by 2020 while issuer terms are current inputs.

## 2. Load the review data into BigQuery

`sql/00_setup_and_load.sql` creates a BigQuery dataset and loads `All_Reviews.csv` from Google Cloud Storage with an explicit nine-column schema. The load permits quoted newlines because review text can span multiple physical CSV lines.

The raw table contains 7,513 review rows and 59 distinct card names.

## 3. Clean with BigQuery Standard SQL

`sql/01_clean_reviews.sql` trims text fields, parses review dates where possible, and converts ratings with `SAFE_CAST`. Values outside the source's 0–5 scale are set to `NULL`; valid half-point ratings are retained.

The clean table contains:

- 7,513 review rows
- 59 distinct card names
- 1,616 usable numeric ratings
- 21.51% numeric-rating coverage
- 3.237005 global mean numeric rating

## 4. Apply an eligibility threshold

A card must contain at least 20 numeric ratings before it can qualify for the top five. This prevents a card with only a few ratings from dominating the results.

## 5. Calculate the Bayesian score

`sql/02_rank_cards.sql` declares a 20-rating minimum and a prior weight of 20. For each card it calculates total reviews, numeric-rating count, average rating, eligibility, and the Bayesian-adjusted score:

```text
Weighted score = (n × card mean + 20 × global mean) ÷ (n + 20)
```

Eligible cards are ranked from highest to lowest weighted score, with average rating, review volume, and card name used as deterministic tie-breakers.

## 6. Research current issuer terms

`sql/03_current_terms.sql` creates a BigQuery comparison table containing manually verified official issuer inputs: monthly finance charge, annual fee, waiver threshold, welcome offer, rewards, benefits, and source URL.

Citi PremierMiles is treated as a legacy reviewed product. Axis Horizon is labeled as its current migrated successor, and Horizon's terms are not presented as historical Citi terms.

## 7. Normalize borrowing cost

Indian issuer pages generally publish a monthly finance charge rather than a U.S.-style APR. BigQuery calculates:

```text
Effective annualized rate = (1 + monthly rate)^12 − 1
```

At 3.75% per month, the result is approximately 55.55% effective annualized.

## 8. Select category leaders

`sql/04_category_leaders.sql` records leaders using the most relevant measure for each category:

- Review rating: highest eligible average rating
- Popularity: greatest review-row volume among the top five
- Borrowing cost: lowest published monthly finance charge
- Annual fee: lowest ongoing fee with the most accessible waiver
- Welcome offer: strongest directly verified offer
- Shopping rewards: strongest explicit cashback structure
- Lifestyle and travel: breadth of relevant verified benefits

## 9. Validate and export

`sql/06_validate.sql` uses BigQuery `ASSERT` statements to verify row count, distinct-card count, numeric-rating count, global mean, and exact top-five order. These assertions were executed successfully in Google BigQuery on 2026-08-15.

`sql/07_export_to_gcs.sql` optionally exports the result tables to Google Cloud Storage as CSV files. The committed processed CSV files and Excel workbook are presentation outputs from the validated BigQuery tables.

## Limitations

- Reviews are India-specific, self-selected, and no later than 2020.
- Numeric ratings are available for only 21.5% of rows.
- Review volume is not market share or customer count.
- The analysis cannot establish causation or represent all cardholders.
- Current fees, rewards, caps, taxes, and eligibility requirements can change.
