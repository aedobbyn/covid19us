
# covid

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/aedobbyn/covid.svg?branch=master)](https://travis-ci.org/aedobbyn/covid)
<!-- badges: end -->

This is an R wrapper around the [COVID Tracking Project
API](https://covidtracking.com/api/)

## Installation

``` r
devtools::install_github("aedobbyn/covid")
```

## Example

``` r
library(covid)

get_states_current()
#> # A tibble: 56 x 8
#>    state positive negative pending death total last_update_et check_time_et
#>    <chr>    <int>    <int>   <int> <int> <int> <chr>          <chr>        
#>  1 AK           3      334      NA    NA   337 3/17 14:30     3/17 21:54   
#>  2 AL          39       28      NA     0    67 3/17 16:30     3/17 21:54   
#>  3 AR          22      197      41    NA   260 3/17 00:00     3/17 21:53   
#>  4 AS           0       NA      NA    NA     0 3/14 00:00     3/17 22:43   
#>  5 AZ          20      142      66     0   228 3/17 00:00     3/17 21:33   
#>  6 CA         483     7981      NA    11  8464 3/16 21:00     3/17 21:57   
#>  7 CO         160     1056      NA     1  1216 3/16 17:00     3/17 21:58   
#>  8 CT          68      125      NA    NA   193 3/17 16:30     3/17 21:59   
#>  9 DC          31      138       1    NA   170 3/17 19:00     3/17 21:37   
#> 10 DE          16       36      NA    NA    52 3/17 15:55     3/17 22:00   
#> # … with 46 more rows
```
