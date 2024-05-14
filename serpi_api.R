library(httr)
library(jsonlite)

#https://serpapi.com/playground?engine=google_jobs&q=Data+Analyst&location=Canada&gl=ca&hl=en
url <- "https://serpapi.com/search"
input_query = "Data Analyst"
params <- list(
  api_key = "b7898852410da8b057026d2d37adecaf7a0238393258a051ac2013a1bf7b4861",
  engine = "google_jobs",
  google_domain = "google.com",
  q = input_query,
  hl = "en",
  gl = "ca",
  location = "Canada"
)

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
} else {
  cat("Error:", status_code(response), "\n")
  cat(content(response, "text"), "\n")
}
