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
    filter = lasR::keep_ground()
  )
  norm_step <- lasR::normalize()
  write_norm <- lasR::write_las(
    ofile = fs::path(output_dir, "normalized", "norm.laz")
    # filter = lasR::keep_class(c(1, 3, 4, 5))
  )
  del = lasR::triangulate(filter = lasR::keep_ground())
  dtm = lasR::rasterize(0.25, del, ofile = fs::path(output_dir, "dtm", "dtm.tif"))
  del2 = lasR::triangulate(filter = lasR::keep_first())
  baba_ras = lasR::rasterize(c(2, 5), operators = c("z_p95", "z_above10", "z_above3"), ofile = fs::path(output_dir, "baba", "baba.tif"))
  chm = lasR::rasterize(0.5, del2)
  chm2 = lasR::pit_fill(chm, ofile = fs::path(output_dir, "chm", "chm.tif"))

  pipeline =
    gnd + write_gnd +
    del + dtm + norm_step + write_norm +
    baba_ras +
    del2 + chm + chm2

  return(pipeline)
}
