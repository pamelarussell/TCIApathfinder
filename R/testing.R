rm(list=ls())

library(httr)

# Get API key from environment variable
api_key <- Sys.getenv("TCIA_API_KEY")

# Make sure API key is set
if(identical(api_key, "")) {
  stop("Please request and store a valid API key (instructions: https://github.com/pamelarussell/TCIApathfinder)")
}

# The base URL and resource
base_url <- "https://services.cancerimagingarchive.net/services/v3"
resource <- "TCIA"

# Function to construct URL from base URL, resource, and endpoint
add_endpoint <- function(endpoint) {
  p <- paste(base_url, resource, endpoint, sep = "/")
  gsub("/+", "/", p)
}

# Function to send the request and get the response
get_response <- function(endpoint, query) {
  response <- GET(add_endpoint(endpoint), query = query)
  warn_for_status(response)
  stop_for_status(response)
}

# Function to get the names of all collections
get_collection_names <- function() {
  response <- get_response("/query/getCollectionValues", 
                           query = list(format = "json", 
                                        api_key = api_key))
  sort(unname(unlist(content(response))))
}





