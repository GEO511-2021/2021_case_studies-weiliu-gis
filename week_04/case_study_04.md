Case Study 04: Farthest airport from New York City
================
Wei Liu
September 30, 2021

## The R packages we need

To begin with, we activate 2 packages, namely *tidyverse* and
*nycflights13* in our workplace.

``` r
library(tidyverse)
library(nycflights13)
```

## Find the farthest airport

To do the task, we need 2 tables - *flights* and *airports* - in the
*nycflights13* dataset. And also, there are some functions we may want,
such as **arrange()**, **inner_join()**, etc.

``` r
flights %>%
  arrange(desc(distance)) %>%
  slice(1) %>% # keep only the first row, since there are many duplicates
  inner_join(airports, by=c("dest"="faa")) %>%
  select(name) %>% # keep only the "name" column
  as.character() # change the data frame to characters
```

    ## [1] "Honolulu Intl"

:) Now we get the answer. The farthest airport is “Honolulu Intl”.
