#' Save a series of DICOM image files to a directory
#'
#' @inheritParams save_image_series
#' @param verbose print diagnostic messages
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{files}: The output zip file that was written
#'   \item \code{dirs}: Directories of the files
#'   \item \code{out_file}: The output zip file that was written
#'   \item \code{response}: API response
#' }
#' @export
#'
#' @examples
#' \dontrun{
#' save_extracted_image_series(
#'      series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867")
#' }
#'
save_extracted_image_series = function(
  series_instance_uid,
  out_dir = NULL,
  verbose = TRUE) {
  tdir = tempfile()
  dir.create(tdir, recursive = TRUE)
  tfile = tempfile(fileext = ".zip")
  tfile = basename(tfile)
  if (verbose) {
    message("Downloading Series")
  }
  res = save_image_series(
    series_instance_uid = series_instance_uid,
    out_dir = tdir,
    out_file_name = tfile)
  if (verbose) {
    message("Unzipping Series")
  }
  stopifnot(file.exists(res$out_file))
  zip_file = res$out_file
  L = extract_image_series(zip_file = zip_file, out_dir = out_dir)
  L$response = res$response
  return(L)
}

#' @export
#' @param zip_file downloaded zip file, usually output of
#' \code{\link{save_image_series}}
#' @rdname save_extracted_image_series
extract_image_series = function(zip_file, out_dir = NULL) {
  if (is.null(out_dir)) {
    out_dir = tempfile()
  }
  dir.create(out_dir, recursive = TRUE)
  res = utils::unzip(zipfile = zip_file, exdir = out_dir)
  L = list(files = res,
           dirs = unique(dirname(normalizePath(res))))
  L$out_file = zip_file
  return(L)
}
