
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shelve: Simple interface to store objects on disk for later use

<!-- badges -->

[![R](https://img.shields.io/badge/language-R-blue)]()
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange)]()
<!-- badges -->

## Idea

The `shelve` package tries to better integrate report generation into
your R code. When creating a report, a common way ist to use
Rmarkdown/Quarto. This is useful for many instance. However, I find that
using it that this somewhat restrict for my way of working.

There are a few relevant concepts:

- `shelf`: A storage for objects
- `shelve`, `unshelve`: Add and retrieve something from a shelf

``` r
library(shelve)

shelf_list()
#> [1] "markheckmann"
shelf_active()
#> [1] "markheckmann"
shelf_activate("test")
shelf_list()
#> [1] "markheckmann" "test"
shelf_remove("test")
#> ✔ shelf 'test' was deleted.
#> ℹ Deleted the active shelf. Active shelf is now 'markheckmann'

shelf_clear()
#> ✔ shelf 'markheckmann' was cleared.
shelf_files()
#> NULL
shelve(mtcars, "cars")
shelf_files()
#> [1] "cars"

unshelve("cars") |> head()
#>                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

Create a report from a shelf.

## Storing objects locally

There are different options to store data on disk. To preserve data
between sessions, we use the `hoards` package, which use `rappdirs`
under the hood.
