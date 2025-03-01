library(httr)
library(jsonlite)
library(dplyr)
library(tidytext)
library(sentimentr)
library(ggplot2)
library(stringr)
library(wordcloud)

# Define API endpoint and parameters
url <- "https://serpapi.com/search"
input_query = "Data Analyst"
params <- list(
  api_key = "YOUR_API_KEY",
  engine = "google_jobs",
  google_domain = "google.com",
  q = input_query,
  hl = "en",
  gl = "ca",
  location = "Canada"
)

# Make API request
response <- GET(url, query = params)

if (status_code(response) == 200) {
  results <- content(response, "parsed")
  
  # Extract relevant information
  job_titles <- sapply(results$jobs, function(x) x$title)
  company_names <- sapply(results$jobs, function(x) x$company_name)
  locations <- sapply(results$jobs, function(x) x$location)
  job_descriptions <- sapply(results$jobs, function(x) x$description)
  
  # Create data frame
  Job_df <- data.frame(
    Job_Title = job_titles,
    Company_Name = company_names,
    Location = locations,
    Job_Description = job_descriptions
  )
  
  View(Job_df)

  # ANALYTICS SECTION

  ## 1. Count of Jobs by Company
  company_count <- as.data.frame(table(Job_df$Company_Name))
  colnames(company_count) <- c("Company", "Job_Count")
  print(company_count)

  ## 2. Count of Jobs by Location
  location_count <- as.data.frame(table(Job_df$Location))
  colnames(location_count) <- c("Location", "Job_Count")
  print(location_count)

  ## 3. Most Common Words in Job Titles
  title_words <- Job_df %>%
    unnest_tokens(word, Job_Title) %>%
    count(word, sort = TRUE)
  
  print(head(title_words, 10))

  ## 4. Sentiment Analysis of Job Descriptions
  sentiment_scores <- sentiment(Job_df$Job_Description)
  sentiment_summary <- summary(sentiment_scores$sentiment)
  print(sentiment_summary)

  ## 5. Word Cloud for Job Titles
  set.seed(1234)
  wordcloud(words = title_words$word, freq = title_words$n, min.freq = 2,
            max.words=100, colors=brewer.pal(8, "Dark2"))

  ## 6. Top 10 Companies Hiring the Most
  top_companies <- company_count %>% arrange(desc(Job_Count)) %>% head(10)
  ggplot(top_companies, aes(x = reorder(Company, Job_Count), y = Job_Count)) +
    geom_bar(stat="identity", fill="steelblue") +
    coord_flip() +
    labs(title="Top 10 Companies Hiring", x="Company", y="Number of Jobs")

  ## 7. Top 10 Locations with the Most Jobs
  top_locations <- location_count %>% arrange(desc(Job_Count)) %>% head(10)
  ggplot(top_locations, aes(x = reorder(Location, Job_Count), y = Job_Count)) +
    geom_bar(stat="identity", fill="darkgreen") +
    coord_flip() +
    labs(title="Top 10 Locations for Jobs", x="Location", y="Number of Jobs")

  ## 8. Average Sentiment Score of Job Descriptions
  avg_sentiment <- mean(sentiment_scores$sentiment)
  print(paste("Average Sentiment Score:", avg_sentiment))

  ## 9. Most Common Phrases in Job Descriptions
  job_phrases <- Job_df %>%
    unnest_tokens(bigram, Job_Description, token = "ngrams", n = 2) %>%
    count(bigram, sort = TRUE)
  
  print(head(job_phrases, 10))

  ## 10. Keyword Search in Job Descriptions (e.g., "SQL")
  keyword <- "SQL"
  keyword_count <- sum(str_count(Job_df$Job_Description, keyword))
  print(paste("Number of job descriptions mentioning", keyword, ":", keyword_count))

} else {
  cat("Error:", status_code(response), "\n")
  cat(content(response, "text"), "\n")
}
