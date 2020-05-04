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
  dat <- get("states/daily")

  if (date != "all") {
    dt <- clean_date(date)
    dat %<>%
      filter(
        date == dt
      )
  }

  if (state != "all") {
    st <- state
    dat %<>%
      filter(
        state == st
      )
  }

  dat
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

data_type_reg <- "death|hospitalized|icu|negative|pending|positive|recovered|total|ventilator"

#' Get state data in long format
#'
#' @param type One of \code{"daily"} or \code{"current"}
#'
#' @return A tibble of data retrieved with \code{\link{get_states_daily}} or \code{\link{get_states_current}} in long format with a \code{data_type} and a \code{value} column.
#' @export
#'
#' @examples
#' \donttest{
#' refresh_covid19us()
#' }
refresh_covid19us <- function(type = "daily") {
  stopifnot(type %in% c("daily", "current"))

  fun <- ifelse(type == "daily", get_states_daily, get_states_current)

  fun() %>%
    tidyr::pivot_longer(
      matches(data_type_reg),
      names_to = "data_type"
    ) %>%
    mutate(
      location_type = "state",
      location_code_type = "fips_code"
    ) %>%
    select(
      date,
      location = state,
      location_type,
      location_code = fips,
      location_code_type,
      data_type,
      value
    )
}
#' Get info about this dataset
#'
#' @return A tibble with information about where the data is pulled from, details about the dataset, what the data types are, etc.
#' @export
#'
#' @examples
#' \donttest{
#' get_info_covid19us()
#' }
get_info_covid19us <- function() {
  latest_data <- refresh_covid19us(type = "daily")

  dplyr::tibble(
    data_set_name = "covid19us",
    package_name = "covid19us",
    function_to_get_data = "refresh_covid19us",
    data_details = "Open Source data from COVID Tracking Project on the distribution of Covid-19 cases and deaths in the US. For more, see https://github.com/opencovid19-fr/data.",
    data_url = "https://covidtracking.com/api",
    license_url = "https://github.com/aedobbyn/covid19us/blob/master/LICENSE.md",
    data_types = latest_data %>%
      tidyr::drop_na(data_type) %>%
      dplyr::pull(data_type) %>%
      unique() %>%
      stringr::str_c(collapse = ", "),
    location_types = latest_data %>%
      tidyr::drop_na(location_type) %>%
      dplyr::pull(location_type) %>%
      unique() %>%
      stringr::str_c(collapse = ", "),
    spatial_extent = "country",
    has_geospatial_info = FALSE
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
