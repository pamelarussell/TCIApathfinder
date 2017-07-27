
test_that("List of collections contains TCGA-BRCA", {
  collections <- get_collection_names()
  expect_true("TCGA-BRCA" %in% collections)
})

test_that("List of collections contains at least 50 elements", {
  collections <- get_collection_names()
  expect_true(length(collections) >= 50)
})

