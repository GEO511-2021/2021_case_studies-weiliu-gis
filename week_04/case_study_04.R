library(tidyverse)
library(nycflights13)

farthest_airport <- flights %>%
  arrange(desc(distance)) %>%
  slice(1) %>% # only keep the first row
  inner_join(airports, by=c("dest"="faa")) %>%
  select(name) # keep only the "name" col
as.character(farthest_airport) # change the data frame to characters

# Extra
airports %>%
  distinct(lon,lat) %>%
  ggplot(aes(lon, lat)) +
  borders("world") +
  geom_point(col="purple") +
  coord_quickmap()