rm(list=ls())

library(httr)
library(jsonlite)

# Function to get API key
get_api_key <- function() {
  api_key <- Sys.getenv("TCIA_API_KEY")
  if(identical(api_key, "")) {
    stop("Please request and store a valid API key (instructions: https://github.com/pamelarussell/TCIApathfinder)")
  }
  api_key
}

# The base URL and resource
api_key <- get_api_key()
base_url <- "https://services.cancerimagingarchive.net/services/v3"
resource <- "TCIA"
ua <- user_agent("https://github.com/pamelarussell/TCIApathfinder")

# Construct URL from base URL, resource, and endpoint
add_endpoint <- function(endpoint) {
  p <- paste(base_url, resource, endpoint, sep = "/")
  gsub("/+", "/", p)
}

# Send the request and get the response
get_response <- function(endpoint, query) {
  response <- GET(add_endpoint(endpoint), ua, query = query)
  warn_for_status(response)
  stop_for_status(response)
}

# Make sure response is JSON
check_json <- function(response) {
  if(http_type(response) != "application/json") {
    stop("API did not return JSON", call. = FALSE)
  }
}

# Turn API error into R error
parse_error <- function(response) {
  if (http_error(response)) {
    stop(
      sprintf(
        "API request failed [%s]\n%s\n<%s>",
        status_code(response),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }
}

# Perform checks of validity parse the response
process_json_response <- function(response) {
  check_json(response)
  parse_error(response)
  fromJSON(content(response, as = "text", encoding = "UTF-8"), simplifyVector = F)
}

#' Get the names of all TCIA collections
#'
#' @return Character vector of collection names
#'
#' @examples
#' get_collection_names()
#'
#' @export
get_collection_names <- function() {
  response <- get_response("/query/getCollectionValues",
                           query = list(format = "json",
                                        api_key = api_key))
  parsed <- process_json_response(response)
  sort(unname(unlist(parsed)))
}






