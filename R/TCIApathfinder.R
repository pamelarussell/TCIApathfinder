
# Get API key
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
ua <- httr::user_agent("https://github.com/pamelarussell/TCIApathfinder")

# Construct URL from base URL, resource, and endpoint
add_endpoint <- function(endpoint) {
  p <- paste(base_url, resource, endpoint, sep = "/")
  gsub("/+", "/", p)
}

# Send the request and get the response
get_response <- function(endpoint, query) {
  response <- httr::GET(add_endpoint(endpoint), ua, query = query)
}

# Make sure response is JSON
check_json <- function(response) {
  if(httr::http_type(response) != "application/json") {
    stop("API did not return JSON", call. = FALSE)
  }
}

# Turn API error into R error
parse_error <- function(response) {
  if (httr::http_error(response)) {
    stop(
      sprintf(
        "API request failed [%s]: %s",
        response$status_code,
        response$url
      ),
      call. = FALSE
    )
  }
}

# Perform checks of validity and parse the response
process_json_response <- function(response) {
  check_json(response)
  parse_error(response)
  jsonlite::fromJSON(httr::content(response, as = "text", encoding = "UTF-8"), simplifyVector = F)
}

#' Get the names of all TCIA collections
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{collection_names}: character vector of TCIA collection names
#'   \item \code{content}: parsed API response content
#'   \item \code{path}: URL path
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' get_collection_names()
#'
#' @export
get_collection_names <- function() {
  endpoint <- "/query/getCollectionValues"
  response <- get_response(endpoint, query = list(format = "json", api_key = api_key))
  parsed <- process_json_response(response)
  collection_names <- sort(unname(unlist(parsed)))
  structure(list(
      collection_names = collection_names,
      content = parsed,
      path = endpoint,
      response = response
    ), class = "tcia_api")
}






