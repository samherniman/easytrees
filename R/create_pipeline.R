#' Create a lasR pipeline to do all the normal stuff
#'
#' @param output_dir directory to save the results
#'
#' @return a lasR pipeline
#' @export
#'
#' @examples
#' pipeline = create_pipeline(".")
#'
create_pipeline <- function(output_dir) {
  gnd <- lasR::classify_with_csf()
  write_gnd <- lasR::write_las(
    ofile = fs::path(output_dir, "unnormalized", "laz.laz"),
    filter = "-keep_class 2"
  )
  norm_step <- lasR::normalize()
  write_norm <- lasR::write_las(
    ofile = fs::path(output_dir, "normalized", "norm.laz"),
    filter = "-keep_class 1 3 4 5"
  )
  del = lasR::triangulate(filter = lasR::keep_ground())
  dtm = lasR::rasterize(0.25, del, ofile = fs::path(output_dir, "dtm", "dtm.tif"))
  del2 = lasR::triangulate(filter = lasR::keep_first())
  t_height = lasR::rasterize(c(2, 5), operators = "z_p95", ofile = fs::path(output_dir, "height_baba", "height_baba.tif"))
  chm = lasR::rasterize(0.5, del2)
  chm2 = lasR::pit_fill(chm, ofile = fs::path(output_dir, "chm", "chm.tif"))

  pipeline =
    gnd + write_gnd +
    del + dtm + norm_step + write_norm +
    t_height +
    del2 + chm + chm2

  return(pipeline)
}
