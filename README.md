
# covid19us

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/aedobbyn/covid19us.svg?branch=master)](https://travis-ci.org/aedobbyn/covid19us)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/aedobbyn/covid19us?branch=master&svg=true)](https://ci.appveyor.com/project/aedobbyn/covid19us)
[![Codecov test
coverage](https://codecov.io/gh/aedobbyn/covid19us/graph/badge.svg)](https://codecov.io/gh/aedobbyn/covid19us)
[![CRAN
status](https://www.r-pkg.org/badges/version/covid19us)](https://CRAN.R-project.org/package=covid19us)
[![License:
MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->

This is an R wrapper around the [COVID Tracking Project
API](https://covidtracking.com/api/). It provides updates on the spread
of the virus in the US with a few simple functions.

## Installation

    install.packages("covid19us")

Or the dev version:

    devtools::install_github("aedobbyn/covid19us")

## Examples

``` r
library(covid19us)
```

Get the most recent COVID-19 top-line data for the country:

``` r
get_us_current()
#> # A tibble: 1 x 6
#>   positive negative hospitalized death  total request_datetime   
#>      <int>    <int>        <int> <int>  <int> <dttm>             
#> 1    33277   210546         2615   418 246330 2020-03-23 17:02:01
```

Or the same by state:

``` r
get_states_current()
#> # A tibble: 56 x 18
#>    state positive positive_score negative_score negative_regula…
#>    <chr>    <int>          <int>          <int>            <int>
#>  1 AK          22              1              1                1
#>  2 AL         157              1              1                0
#>  3 AR         168              1              1                1
#>  4 AZ         152              1              1                1
#>  5 CA        1536              1              1                1
#>  6 CO         591              1              1                1
#>  7 CT         327              1              1                1
#>  8 DC         116              1              1                1
#>  9 DE          68              1              1                0
#> 10 FL        1171              1              1                1
#> # … with 46 more rows, and 13 more variables: commercial_score <int>,
#> #   grade <chr>, score <int>, negative <int>, pending <int>,
#> #   hospitalized <int>, death <int>, total <int>, last_update <dttm>,
#> #   check_time <dttm>, date_modified <dttm>, date_checked <dttm>,
#> #   request_datetime <dttm>
```

Daily state counts can be filtered by state and/or date:

``` r
get_states_daily(
  state = "NY", 
  date = "2020-03-17"
)
#> # A tibble: 1 x 10
#>   date       state positive negative pending hospitalized death total
#>   <date>     <chr>    <int>    <int> <lgl>   <lgl>        <int> <int>
#> 1 2020-03-17 NY        1700     5506 NA      NA               7  7206
#> # … with 2 more variables: date_checked <dttm>, request_datetime <dttm>
```

## All Functions

    get_counties_info
    get_states_current
    get_states_daily
    get_states_info
    get_tracker_urls
    get_us_current
    get_us_daily

## Other Details

  - All of the data sources can be found with `get_tracker_urls()`
    
      - The `filter` column gives information about how the [COVID
        Tracking Project’s
        scraper](https://github.com/COVID19Tracking/covid-tracking)
        currently scrapes data from the page (xpaths, CSS selectors,
        functions used, etc.)

  - State breakdowns include DC as well as some US territories including
    American Samoa (AS), Guam (GU), Northern Mariana Islands (MP),
    Puerto Rico (PR), and the Virgin Islands (VI)

  - Acronyms
    
      - PUI: persons under investigation
      - PUM: persons under monitoring (one step before PUI)

  - Time zone used is Eastern Standard Time

-----

**[PR](https://github.com/aedobbyn/covid19us/pulls)s and [bug reports /
feature requests](https://github.com/aedobbyn/covid19us/issues)
welcome.** Stay safe\!
