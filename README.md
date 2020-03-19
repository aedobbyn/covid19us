
# covid19us

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/aedobbyn/covid19us.svg?branch=master)](https://travis-ci.org/aedobbyn/covid19us)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/aedobbyn/covid19us?branch=master&svg=true)](https://ci.appveyor.com/project/aedobbyn/covid19us)
[![Codecov test
coverage](https://codecov.io/gh/aedobbyn/covid19us/graph/badge.svg)](https://codecov.io/gh/aedobbyn/covid19us)
<!-- badges: end -->

This is an R wrapper around the [COVID Tracking Project
API](https://covidtracking.com/api/). It provides updates on the spread
of the virus in the US with a few simple functions.

## Installation

``` r
devtools::install_github("aedobbyn/covid19us")
```

## Examples

``` r
library(covid19us)
```

Get the most recent COVID-19 top-line data for the country:

``` r
get_us_current()
#> # A tibble: 1 x 6
#>   positive negative pending death total request_datetime   
#>      <int>    <int>   <int> <int> <int> <dttm>             
#> 1     8131    71635    2805   132 82571 2020-03-19 09:57:22
```

Or the same by state:

``` r
get_states_current()
#> # A tibble: 56 x 9
#>    state positive negative pending death total last_update        
#>    <chr>    <int>    <int>   <int> <int> <int> <dttm>             
#>  1 AK           6      400      NA    NA   406 2020-03-18 16:30:00
#>  2 AL          51       28      NA     0    79 2020-03-18 17:10:00
#>  3 AR          37      284     112    NA   433 2020-03-18 18:34:00
#>  4 AS           0       NA      NA     0     0 2020-03-14 00:00:00
#>  5 AZ          28      148     102     0   278 2020-03-18 00:00:00
#>  6 CA         611     7981      NA    13  8592 2020-03-17 21:00:00
#>  7 CO         216     2112      NA     2  2328 2020-03-18 18:30:00
#>  8 CT          96      604      NA     1   700 2020-03-18 22:00:00
#>  9 DC          39      153      11    NA   203 2020-03-18 19:00:00
#> 10 DE          26       36      NA    NA    62 2020-03-18 13:50:00
#> # … with 46 more rows, and 2 more variables: check_time <dttm>,
#> #   request_datetime <dttm>
```

Daily state counts can be filtered by state and/or date:

``` r
get_states_daily(
  state = "NY", 
  date = "2020-03-17"
)
#> # A tibble: 1 x 9
#>   date       state positive negative pending death total date_checked       
#>   <date>     <chr>    <int>    <int> <lgl>   <int> <int> <dttm>             
#> 1 2020-03-17 NY        1700     5506 NA          7  7206 2020-03-17 20:00:00
#> # … with 1 more variable: request_datetime <dttm>
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

  - Time zone used is Eastern Standard Time

-----

**[PR](https://github.com/aedobbyn/covid19us/pulls)s and [bug reports /
feature requests](https://github.com/aedobbyn/covid19us/issues)
welcome.** Stay safe\!
