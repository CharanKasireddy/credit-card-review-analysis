# Methodology

## 1. Define the business question

The project identifies the strongest reviewed cards in the dataset and then determines which current product leads borrowing cost, annual fee, welcome offer, rewards, or overall benefits.

Review sentiment and current product value are analyzed separately because the review data was published by 2020 while issuer terms are current inputs.

## 2. Inspect and clean the review data

The source workbook contains:

- 7,513 review rows
- 59 distinct card names
- 1,616 usable numeric ratings
- 21.5% numeric-rating coverage

The `Ratings` field is converted to a number with invalid or nonnumeric entries treated as missing. Total review volume and numeric-rating volume remain separate measures.

## 3. Apply an eligibility threshold

A card must contain at least 20 numeric ratings before it can qualify for the top five. This prevents a card with only a few ratings from dominating the results.

## 4. Calculate the Bayesian score

The global numeric-rating mean is 3.237 and the prior weight is 20 ratings.

```text
Weighted score = (n × card mean + 20 × global mean) ÷ (n + 20)
```

Eligible cards are ranked from highest to lowest weighted score.

## 5. Research current issuer terms

Official issuer pages were used to collect monthly finance charges, annual fees, fee-waiver thresholds, welcome offers, rewards, and benefits. These are manually verified inputs, not fields from the Kaggle data.

Citi PremierMiles is treated as a legacy reviewed product. Axis Horizon is labeled as its current migrated successor, and Horizon's terms are not presented as historical Citi terms.

## 6. Normalize borrowing cost

Indian issuer pages generally publish a monthly finance charge rather than a U.S.-style APR. The project uses this comparison calculation:

```text
Effective annualized rate = (1 + monthly rate)^12 − 1
```

At 3.75% per month, the result is approximately 55.55% effective annualized.

## 7. Select category leaders

Leaders are selected using the most relevant measure for each category:

- Review rating: highest eligible average rating
- Popularity: greatest review-row volume among the top five
- Borrowing cost: lowest published monthly finance charge
- Annual fee: lowest ongoing fee with the most accessible waiver
- Welcome offer: strongest directly verified first-year offer
- Shopping rewards: strongest explicit cashback structure
- Lifestyle and travel: breadth of relevant verified benefits

## Limitations

- Reviews are India-specific, self-selected, and no later than 2020.
- Numeric ratings are available for only 21.5% of rows.
- Review volume is not market share or customer count.
- The analysis cannot establish causation or represent all cardholders.
- Current fees, rewards, caps, taxes, and eligibility requirements can change.

