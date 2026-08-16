# Contributing

Contributions that improve BigQuery reproducibility, documentation, source verification, or visualization accessibility are welcome.

1. Create a branch from `main`.
2. Keep current issuer terms separate from review-derived metrics.
3. Document every external input in `docs/SOURCES.md`.
4. Replace the project and bucket placeholders, run `sql/00_setup_and_load.sql` through `sql/06_validate.sql` in BigQuery, and confirm every assertion passes.
5. Regenerate the processed exports and workbook if analytical outputs change.
6. Open a pull request explaining the SQL change and any limitations.

Do not commit credentials, Google Cloud keys, private application data, or personally identifiable cardholder information.
