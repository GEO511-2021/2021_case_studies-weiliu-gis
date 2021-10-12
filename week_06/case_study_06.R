library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)

data(world)  #load 'world' data from spData package

world_new <- filter(world, continent!="Antarctica")
world_sp <- as(world_new,"Spatial")

tmax_monthly <- getData(name = "worldclim", var="tmax", res=10)

# plot(tmax_monthly) # this will take too much time, so I don't want to do it every time I run the code.

gain(tmax_monthly) <- 0.1 # I was not sure what's happening here, but the result seems correct.

tmax_annual <- max(tmax_monthly)
names(tmax_annual) <- "tmax"

# extract the value from the raster to the polygon
max_temp <- raster::extract(tmax_annual, world_sp,
                fun=max, na.rm=T, small=T, sp=T) %>%
  st_as_sf()

# do the plotting!!!
ggplot(max_temp, aes(fill=tmax)) +
  geom_sf() +
  scale_fill_viridis_c(name="Annual\nMaximum\nTemperature (C)") +
  theme(legend.position = 'bottom')

# find the hottest country in each continent
hottest_country <- max_temp %>%
  group_by(continent) %>%
  top_n(1, tmax) %>%
  select(name_long, continent, tmax) %>%
  st_set_geometry(NULL) %>%
  arrange(desc(tmax))

hottest_country
