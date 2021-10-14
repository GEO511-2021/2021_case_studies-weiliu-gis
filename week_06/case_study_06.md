Case Study 06: Find hottest country on each continent
================
Wei Liu
October 11th, 2021

## We need these following packages

``` r
library(raster)
library(sp)
library(spData)
library(tidyverse)
library(sf)
```

## Prepare the data

**Polygons: world —&gt; world\_sp**

``` r
data(world)  #load 'world' data from spData package
world_new <- filter(world, continent!="Antarctica")
world_sp <- as(world_new,"Spatial")
```

**Raster: tmax\_monthly —&gt; tmax\_annual**

``` r
tmax_monthly <- getData(name = "worldclim", var="tmax", res=10)
gain(tmax_monthly) <- 0.1
tmax_annual <- max(tmax_monthly)
names(tmax_annual) <- "tmax"
```

## Extract the value and make a plot

``` r
max_temp <- raster::extract(tmax_annual, world_sp,
                fun=max, na.rm=T, small=T, sp=T) %>%
  st_as_sf()
ggplot(max_temp, aes(fill=tmax)) +
  geom_sf() +
  scale_fill_viridis_c(name="Annual\nMaximum\nTemperature (C)") +
  theme(legend.position = 'bottom')
```

<img src="case_study_06_files/figure-gfm/unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

## Find the hottest country in each continent

``` r
hottest_country <- max_temp %>%
  group_by(continent) %>%
  top_n(1, tmax) %>%
  select(name_long, continent, tmax) %>%
  st_set_geometry(NULL) %>%
  arrange(desc(tmax))

knitr::kable(hottest_country) # inspired by Hui
```

| name\_long                          | continent               | tmax |
|:------------------------------------|:------------------------|-----:|
| Algeria                             | Africa                  | 48.9 |
| Iran                                | Asia                    | 46.7 |
| United States                       | North America           | 44.8 |
| Australia                           | Oceania                 | 41.8 |
| Argentina                           | South America           | 36.5 |
| Spain                               | Europe                  | 36.1 |
| French Southern and Antarctic Lands | Seven seas (open ocean) | 11.8 |
