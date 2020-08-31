## Test environments
* local OS X install, R 3.6.2
* ubuntu 14.04 (on travis-ci), R 3.6.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

* This version turns all columns in the wide data version to character before pivoting to a longer version of the data so that all data types can be combined into one column.
