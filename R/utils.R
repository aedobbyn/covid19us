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
    tbl <-
      lst %>%
      purrr::map(replace_null) %>%
      tibble::as_tibble()
  } else {
    tbl <-
      lst %>%
      purrr::modify_depth(2, replace_null) %>%
      purrr::map(tibble::as_tibble) %>%
      bind_rows()
  }

  tbl %<>%
    rename_all(
      snakecase::to_snake_case
    ) %>%
    # Remove Eastern Time suffix if it exists
    rename_all(
      stringr::str_remove_all,
      "_et"
    ) %>%
    # In case stray spaces get in on some runs and mess with joins on e.g. state abbreviation
    mutate_if(
      is.character,
      stringr::str_squish
    )

  # pos_neg is just the sum of positive and negative so doesn't add much new info
  suppressWarnings(
    tbl %<>%
      select(
        -one_of("pos_neg")
      )
  )

  date_vars <-
    names(tbl) %>%
    .[stringr::str_detect(., "date|update|time")]

  tbl %>%
    mutate_at(
      date_vars,
      clean_date
    ) %>%
    mutate(
      request_datetime = lubridate::now()
    )
}

get <- function(endpoint, query = "") {
  url <- glue::glue("{base_url}{endpoint}{query}")
  request(url)
}

replace_null <- function(x) {
  if (length(x) == 0) {
    NA
  } else {
    x
  }
}

date_to_int <- function(x) {
  x %>%
    lubridate::as_date() %>%
    stringr::str_remove_all("-") %>%
    as.integer()
}

clean_date <- function(x) {
  if (all(stringr::str_detect(x, "[A-Z]+"))) {
    # For the dateChecked case
    x %>%
      stringr::str_remove_all("[A-Z]+") %>%
      lubridate::as_datetime(
        tz = "America/New_York"
      )
  } else if (all(stringr::str_detect(x, "/"))) {
    # For the `check_time` case in `get_states_current()`
    x %>%
      stringr::str_replace(" ", "/20 ") %>%
      lubridate::mdy_hm(
        tz = "America/New_York"
      )
  } else {
    # For the `date` case in get_states_daily()
    x %>%
      lubridate::ymd()
  }
}
