
test_that("List of collections contains TCGA-BRCA", {
  collections <- get_collection_names()
  expect_true("TCGA-BRCA" %in% collections)
})

