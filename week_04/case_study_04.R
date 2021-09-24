library(tidyverse)
library(nycflights13)

farthest_airport <- flights %>%
  arrange(desc(distance)) %>%
  slice(1) %>%
  inner_join(airports, by=c("dest"="faa")) %>%
  select(name)

View(x)