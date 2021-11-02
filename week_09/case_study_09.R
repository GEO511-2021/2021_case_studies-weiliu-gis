library(sf)
library(tidyverse)
library(ggmap)
library(rnoaa)
library(spData)
data(world)
data(us_states)

# Download zipped data from noaa with storm track information
dataurl="https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.NA.list.v04r00.points.zip"
tdir=tempdir()
download.file(dataurl,destfile=file.path(tdir,"temp.zip"))
unzip(file.path(tdir,"temp.zip"),exdir = tdir)
list.files(tdir)

storm_data <- read_sf(list.files(tdir,pattern=".shp",full.names = T))

storm_filtered <- storm_data %>%
  filter(SEASON >= 1950) %>%
  mutate_if(is.numeric, function(x) ifelse(x==-999.0,NA,x)) %>%
  mutate(decade=(floor(year/10)*10))
region <- st_bbox(storm_filtered)

ggplot() +
  geom_sf(data=world, inherit.aes=F) +
  facet_wrap(~decade) +
  stat_bin2d(data=storm_filtered,
             aes(y=st_coordinates(storm_filtered)[,2],
                 x=st_coordinates(storm_filtered)[,1]),
             bins=100) +
  scale_fill_distiller(palette="YlOrRd", trans="log",
                       direction=-1, breaks = c(1,10,100,1000)) +
  coord_sf(ylim=region[c(2,4)], xlim=region[c(1,3)]) +
  theme(axis.title=element_blank())

us_states = st_transform(us_states, crs=st_crs(storm_filtered))
colnames(us_states)[colnames(us_states) == "NAME"] <- "STATE"

storm_states <- st_join(storm_filtered, us_states, join = st_intersects,left = F) %>%
  group_by(STATE) %>%
  summarize(storms=length(unique(NAME))) %>%
  arrange(desc(storms)) %>%
  slice(1:5)