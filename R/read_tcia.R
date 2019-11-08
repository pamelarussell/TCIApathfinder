na.locf <- function(x) {
  v <- !is.na(x)
  c(NA, x[v])[cumsum(v) + 1]
}

#' Read TCIA file
#'
#' @param file path to file from TCIA, usually with extension \code{tcia}
#'
#' @return A list of values
#' @export
#'
#' @examples
#' file = system.file("doiJNLP-T5OW0OWM.tcia", package = "TCIApathfinder")
#' res = read_tcia(file)
#' testthat::expect_equal(res$noOfrRetry, "4")
#' testthat::expect_equal(length(res$ListOfSeriesToDownload), 82L)
read_tcia = function(file) {
  x = readLines(file, warn = FALSE)
  vals = grepl("=", x)
  val = rep(NA, length = length(x))
  val[ vals] = sub("=.*", "", x[vals])
  val = na.locf(val)
  if (any(is.na(val))) {
    stop("Cannot parse TCIA file")
  }
  x = sub(".*=", "", x)
  ss = split(x, val)
  ss = lapply(ss, function(x) {
    x[ x %in% "" ] =  NA
    x = na.omit(x)
    if (length(x) == 0) {
      x = NA_character_
    }
    x = as.character(x)
    x
  })

  return(ss)

}
