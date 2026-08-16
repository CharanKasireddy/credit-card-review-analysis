# BigQuery SQL pipeline

This folder contains the complete analysis in Google BigQuery Standard SQL. Replace `YOUR_PROJECT_ID` and `YOUR_BUCKET` in the scripts before running them.

## Run order

1. Upload `data/raw/All_Reviews.csv` to a Google Cloud Storage bucket.
2. Run `00_setup_and_load.sql` to create the dataset and load the CSV.
3. Run `01_clean_reviews.sql` through `06_validate.sql` in numeric order.
4. Optionally run `07_export_to_gcs.sql` to export the result tables as CSV files.

All analysis logic is in SQL:

- source loading and schema definition;
- cleaning and safe rating conversion;
- review aggregation and Bayesian scoring;
- eligibility and ranking;
- current-product comparison inputs;
- category-leader outputs;
- automated assertions; and
- optional CSV exports.

The dataset and Cloud Storage bucket must use compatible locations. The scripts default the dataset to `US`; change the `location` option if your bucket is elsewhere.

## Expected validation results

- 7,513 review rows
- 59 distinct cards
- 1,616 usable numeric ratings
- 3.2370049505 global mean numeric rating
- Top card: Axis Bank Myzone Credit card

The `ASSERT` statements in `06_validate.sql` stop execution if these checks fail.
