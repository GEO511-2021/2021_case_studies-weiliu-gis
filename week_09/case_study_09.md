Case Study 09: Tracking Hurricanes!
================
Wei Liu
November 2, 2021

## Libraries

``` r
library(sf)
library(tidyverse)
library(ggmap)
library(rnoaa)
library(spData)
library(knitr)
data(world)
data(us_states)
```

## Download data

``` r
dataurl="https://www.ncei.noaa.gov/data/international-best-track-archive-for-climate-stewardship-ibtracs/v04r00/access/shapefile/IBTrACS.NA.list.v04r00.points.zip"
tdir=tempdir()
download.file(dataurl,destfile=file.path(tdir,"temp.zip"))
unzip(file.path(tdir,"temp.zip"),exdir = tdir)
list.files(tdir)
```

## Prepare the data

``` r
storm_data <- read_sf(list.files(tdir,pattern=".shp",full.names = T))

storm_filtered <- storm_data %>%
  filter(SEASON >= 1950) %>%
  mutate_if(is.numeric, function(x) ifelse(x==-999.0,NA,x)) %>%
  mutate(decade=(floor(year/10)*10))
region <- st_bbox(storm_filtered)
```

## Make the plot

``` r
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
```

<img src="case_study_09_files/figure-gfm/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

## Calculate table of the five states with most storms

``` r
us_states = st_transform(us_states, crs=st_crs(storm_filtered))
colnames(us_states)[colnames(us_states) == "NAME"] <- "STATE"

storm_states <- st_join(storm_filtered, us_states, join = st_intersects,left = F) %>%
  group_by(STATE) %>%
  summarize(storms=length(unique(NAME))) %>%
  arrange(desc(storms)) %>%
  slice(1:5) %>%
  st_set_geometry(NULL) # Remove the geomerty column from the table

kable(storm_states)
```

| STATE          | storms |
|:---------------|-------:|
| Florida        |     84 |
| North Carolina |     64 |
| Georgia        |     60 |
| Texas          |     54 |
| Louisiana      |     52 |
