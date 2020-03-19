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

