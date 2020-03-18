source(here::here("database/scrapers/utils.R"))

base_url <- "https://covidtracking.com/api/"

request <- function(url) {
  resp <-
    httr::GET(url) %>%
    httr::stop_for_status()

  lst <- httr::content(resp)

  lst %>%
    purrr::modify_depth(2, replace_null) %>%
    purrr::map(tibble::as_tibble) %>%
    bind_rows()
}

get <- function(endpoint) {
  url <- elmers("{base_url}{endpoint}")
  request(url)
}

get_states_current <- get("states")
get_states_daily <- get("states/daily")
get_states_info <- get("states/info")
get_us_current <- get("us")

