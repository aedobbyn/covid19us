#' Get current counts for every state
#'
#' @return A tibble with one row per state and columns for individuals' COVID statuses (positive, negative, pending, death) and their total.
#' @export
#'
#' @examples
#' \donttest{
#' get_states_current()
#' }
get_states_current <- function() {
  get("states")
}

#' Get daily counts for every state
#'
#' Daily counts are updated every day at 4pm EST. This is the only function that takes arguments.
#'
#' @param state State abbreviation for a specific state or all states with \code{"all"}.
#' @param date For a specific date, a character or date vector of length 1 coercible to a date with \code{lubridate::as_date()}.
#'
#' @return A tibble with one row per state for all dates available with columns for individuals' COVID statuses (positive, negative, pending, death) and their total.
#' @export
#'
#' @examples
#' \donttest{
#' get_states_daily()
#'
#' get_states_daily("NY", "2020-03-17")
#' get_states_daily(state = "WA")
#' get_states_daily(date = "2020-03-11")
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

  get("states/daily", query = q)
}

#' Get COVID-related information for each state
#'
#' @return A tibble with one row per state incluing information on the state's \code{data_site} where the data was pulled from and the \code{covid_19_site} where data is published.
#' @export
#'
#' @examples
#' \donttest{
#' get_states_info()
#' }
get_states_info <- function() {
  tbl <- get("states/info")

  if (nrow(tbl) == 0) {
    return(tbl)
  }

  tbl %>%
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
#' \donttest{
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
#' \donttest{
#' get_us_daily()
#' }
get_us_daily <- function() {

  tbl <- get("us/daily")

  if (nrow(tbl) == 0) {
    return(tbl)
  }

  tbl %>%
    rename(
      n_states = states
    ) %>%
    arrange(
      desc(date)
    )
}

#' Get COVID-related information for certain counties
#'
#' Currently limited to the worst-affected counties in mostly Washington state, California, and New York.
#'
#' @return A tibble with one row per county and their COVID website information.
#' @export
#'
#' @examples
#' \donttest{
#' get_counties_info()
#' }
get_counties_info <- function() {
  get("counties")
}

#' Get URLs and their details for each state
#'
#' @return A tibble with one row for every state, the URL used by scrapers to get data, and a \code{filter} column that provices the xpath or CSS selector used by the \href{https://github.com/COVID19Tracking/covid-tracking}{COVID-19 Tracking Project's scraper} to get this data.
#' @export
#'
#' @examples
#' \donttest{
#' get_tracker_urls()
#' }
get_tracker_urls <- function() {
  tbl <- get("urls")

  if (nrow(tbl) == 0) {
    return(tbl)
  }

  tbl %>%
    rename(
      state_name = name
    ) %>%
    select(
      state_name, url, filter, ssl_no_verify, kind, request_datetime
    )
}
