test_that("get_states_daily works", {
  # Many rows
  full <- get_states_daily()

  # One state
  ct <- get_states_daily("CT")

  # One one state one date
  specific <- get_states_daily("NY", "2020-03-17")

  # Zero rows
  too_early <- get_states_daily(date = "2019-08-25")

  nms <-
    c("date", "state", "positive", "negative", "pending", "death", "total", "date_checked", "request_datetime")

  if (nrow(full) > 0) expect_named(full, nms)
  if (nrow(ct) > 0) expect_named(ct, nms)
  if (nrow(specific) > 0) expect_named(specific, nms)

  if (nrow(full) > 0) expect_gte(nrow(full), 500)
  if (nrow(ct) > 0) expect_gte(nrow(ct), 10)
  if (nrow(specific) > 0) expect_equal(nrow(specific), 1)
  expect_equal(nrow(too_early), 0)
})

test_that("other funs work", {
  states_current <- get_states_current()

  if (nrow(states_current) > 0) {
    expect_is(
      c(
        states_current$last_update,
        states_current$check_time
      ),
      "POSIXct"
    )
  }

  states_info <- get_states_info()
  if (nrow(states_info) > 0) {
    expect_gte(ncol(states_info), 6)
  }

  us_current <- get_us_current()
  if (nrow(us_current) > 0) expect_equal(nrow(us_current), 1)

  us_daily <- get_us_daily()
  if (nrow(us_daily) > 0) expect_gte(nrow(us_daily), 10)

  counties_info <- get_counties_info()
  if (nrow(counties_info) > 0) {
    expect_gte(length(unique(counties_info$state)), 3)
  }

  urls <- get_tracker_urls()
  url_names <- c("state_name", "url", "filter", "ssl_no_verify", "kind", "request_datetime")
  if (nrow(urls) > 0) expect_named(urls, url_names)
})
