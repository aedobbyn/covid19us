#' @import dplyr

base_url <- "https://covidtracking.com/api/"

request <- function(url) {
  resp <-
    httr::GET(url) %>%
    httr::stop_for_status()

  lst <- httr::content(resp)

  if (length(lst) == 0) {
    message("No results for this request.")
    return(tibble::tibble())
  }

  # Only one result
  if (length(lst[[1]]) == 1) {
    return(
      lst %>%
        purrr::map(replace_null) %>%
        tibble::as_tibble()
    )
  }

  lst %>%
    purrr::modify_depth(2, replace_null) %>%
    purrr::map(tibble::as_tibble) %>%
    bind_rows() %>%
    rename_all(
      snakecase::to_snake_case
    )
}

get <- function(endpoint, query = "") {
  url <- glue::glue("{base_url}{endpoint}{query}")
  request(url)
}

#' Get current counts for every state
#'
#' @return A tibble with one row per state and columns for individuals' COVID statuses (positive, negative, pending, death) and their total.
#' @export
#'
#' @examples
#' \dontrun{
#' get_states_current()
#' }
get_states_current <- function() {
  get("states") %>%
    # Remove Eastern Time
    rename_all(
      stringr::str_remove_all,
      "_et"
    ) %>%
    mutate_at(
      vars(last_update, check_time),
      clean_date
    )
}

#' Get daily counts for every state
#'
#' Updated every day at 4pm.
#'
#' @param state State abbreviation for a specific state or all states with \code{"all"}.
#' @param date For a specific date, a character or date vector of length 1 coercible to a date with \code{lubridate::as_date()}.
#'
#' @return A tibble with one row per state for all dates available with columns for individuals' COVID statuses (positive, negative, pending, death) and their total.
#' @export
#'
#' @examples
#' \dontrun{
#' get_states_daily()
#'
#' get_states_daily("NY", "2020-03-17")
#' get_states_daily("WA")
#' }
get_states_daily <- function(state = "all", date = "all") {

  if (state == "all" && date == "all") {
    q <- ""
  } else {
    if (date != "all") {
      date %<>%
        date_to_int()

      # All states, specific date
      if (state == "all") {
        q <- glue::glue("?date={date}")
      # Specific state and specific date
      } else {
        q <- glue::glue("?state={state}&date={date}")
      }
    # Specific state, all dates
    } else {
      q <- glue::glue("?state={state}")
    }
  }

  get("states/daily", query = q) %>%
    mutate_at(
      vars(date, date_checked),
      clean_date
    )
}

#' Get information in each state
#'
#' @return A tibble with one row per state incluing information on the state's \code{data_site} where the data was pulled from and the \code{covid_19_site} where data is published.
#' @export
#'
#' @examples
#' \dontrun{
#' get_states_info()
#' }
get_states_info <- function() {
  get("states/info") %>%
    select(
      state, name,
      everything()
    )
}

#' Get current US counts
#'
#' @return A tibble with one row for the current count of the country's COVID statuses.
#' @export
#'
#' @examples
#' \dontrun{
#' get_us_current()
#' }
get_us_current <- function() {
  get("us")
}

#' Get daily US counts
#'
#' Updated every day at 4pm.
#'
#' @return A tibble with one row per date in which data is available and counts for each of those states.
#' @export
#'
#' @examples
#' \dontrun{
#' get_us_daily()
#' }
get_us_daily <- function() {
  get("us/daily") %>%
    rename(
      n_states = states
    ) %>%
    mutate(
      date = clean_date(date)
    ) %>%
    arrange(
      desc(date)
    )
}

#' Get counts by US county
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' get_counties()
#' }
get_counties <- function() {
  get("counties")
}

#' Get URLs and their details for each state
#'
#' Includes the xpath css selector used to get data.
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' get_tracker_urls()
#' }
get_tracker_urls <- function() {
  get("urls")
}

