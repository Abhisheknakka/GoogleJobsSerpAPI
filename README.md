# Job Scraper with SerpAPI

## Overview

This script extracts job postings for a given query (e.g., 'Data Analyst') in Canada using SerpAPI and processes the retrieved data using R. It fetches job titles, company names, locations, and descriptions, and then displays the results in a data frame.

## Prerequisites

- R installed on your system
- `httr` and `jsonlite` libraries installed in R
- A valid SerpAJPI key

## Installation

1. Install the required R packages if they are not already installed:
   ```r
   install.packages("httr")
   install.packages("jsonlite")
   ```
2. Replace `api_key` in the script with your own SerpAPI key.

## Usage

1. Run the script in RStudio or an R environment.
2. The extracted job postings will be displayed in a data frame using `View(Job_df)`.

## Script Breakdown

1. **Define API endpoint and parameters:**

   - The script sets the API endpoint (`https://serpapi.com/search`) and parameters such as query term (`q`), location, and API key.

2. **Make API request:**

   - The `GET` function from the `httr` package is used to send the request.
   - The response is checked for successful execution.

3. **Extract relevant job information:**

   - `sapply()` is used to extract `title`, `company_name`, `location`, and `description` fields.
   - Data is stored in a data frame (`Job_df`).

4. **Display results:**

   - `View(Job_df)` shows the job listings in a tabular format.

## Additional Analytics

For interview preparation, the script has been extended to include analytics:

### 1. Count of Jobs by Company

```r
company_count <- table(Job_df$Company_Name)
print(company_count)
```

This provides a frequency count of job postings by company.

### 2. Count of Jobs by Location

```r
location_count <- table(Job_df$Location)
print(location_count)
```

This shows the number of job postings in each location.

### 3. Most Common Words in Job Titles

```r
library(dplyr)
library(tidytext)

title_words <- Job_df %>%
  unnest_tokens(word, Job_Title) %>%
  count(word, sort = TRUE)

print(head(title_words, 10))
```

This extracts the most common words in job titles to help identify keyword trends.

### 4. Sentiment Analysis of Job Descriptions

```r
library(sentimentr)

sentiment_scores <- sentiment(Job_df$Job_Description)
summary(sentiment_scores$sentiment)
```

This performs sentiment analysis on job descriptions to understand the overall tone of job postings.

## Future Enhancements

- Include salary estimates from job descriptions using regex.
- Generate visualizations for job trends using `ggplot2`.
- Implement keyword analysis on job descriptions.

## Notes

- Ensure the API key is kept private and not shared in public repositories.
- API requests are limited by SerpAPI's rate limits based on the subscription plan.

## Author

Abhishek Nakka

