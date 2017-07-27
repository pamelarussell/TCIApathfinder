
test_that("User agent is GitHub repo", {
  response <- get_response("/query/getCollectionValues",
                           query = list(format = "json",
                                        api_key = api_key))
  expect_identical(response[["request"]][["options"]][["useragent"]], "https://github.com/pamelarussell/TCIApathfinder")
})

