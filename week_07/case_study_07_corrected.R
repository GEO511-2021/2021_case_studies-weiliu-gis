library(tidyverse)
library(reprex)
library(sf)

library(spData)
data(world)

ggplot(world,aes(x=gdpPercap, color=continent, fill=continent)) +
  geom_density(alpha=0.5,color=F) +
  xlab("GDP Per Capita") +
  ylab("Density")