
base_url <- "https://covidtracking.com/api/"

request <- function(url) {
  resp <-
    httr::GET(url) %>%
    httr::stop_for_status()

  lst <- httr::content(resp)

  lst %>%
    purrr::modify_depth(2, replace_null) %>%
    purrr::map(tibble::as_tibble) %>%
    dplyr::bind_rows() %>%
    dplyr::rename_all(
      snakecase::to_snake_case
    )
}

get <- function(endpoint) {
  url <- glue::glue("{base_url}{endpoint}")
  request(url)
}

#' @export
get_states_current <- function() {
  get("states")
}

#' @export
get_states_daily <- function() {
  get("states/daily")
}

#' @export
get_states_info <- function() {
  get("states/info")
}

#' @export
get_us_current <- function() {
  get("us")
}

#' @export
get_us_daily <- function() {
  get("us/daily")
}

#' @export
get_counties <- function() {
  get("counties")
}

#' @export
get_tracker_urls <- function() {
  get("urls")
}

