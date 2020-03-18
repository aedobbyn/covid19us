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
