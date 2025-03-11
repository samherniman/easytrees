pipeline = create_pipeline(".")

test_that("multiplication works", {
  expect_length(pipeline, 10)
})
