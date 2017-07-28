
test_that("Structure of collection names value", {
  collections <- get_collection_names()
  expect_equal(length(collections), 4)
  expect_identical(collections$path, "/query/getCollectionValues")
  expect_true(length(collections$content) > 50)
})

test_that("List of collections contains TCGA-BRCA", {
  collections <- get_collection_names()
  expect_true("TCGA-BRCA" %in% collections$collection_names)
})

test_that("List of collections contains more than 50 elements", {
  collections <- get_collection_names()
  expect_true(length(collections$collection_names) > 50)
})

