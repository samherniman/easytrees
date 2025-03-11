#' Setup directories for pipeline
#'
#' @param output_dir directory to save the results
#'
#' @return path to output_dir
#' @export
setup_pipeline <- function(output_dir) {
  fs::dir_create(fs::path(
    output_dir,
    c("chm", "dtm", "height_baba", "unnormalized", "normalized", "treetops")
  ))
  return(output_dir)
}
