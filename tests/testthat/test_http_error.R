
test_that("Error for invalid endpoint", {
  response <- get_response("/fakeEndpoint", query = list(format = "json", api_key = api_key))
  expect_error(parse_error(response), "\\[404\\]: [a-zA-Z0-9:/.]+fakeEndpoint")
})

