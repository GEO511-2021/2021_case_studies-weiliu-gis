# Case 3: Wealth over time
#-----------------------------------------
# Wei Liu
# 09/20/2021, updated on 09/21/2021
#-----------------------------------------

library(ggplot2)
library(gapminder)
library(dplyr)
library(here)
 
# plot 1
gap_filtered <- gapminder %>%
   filter(country != "Kuwait")
 
p1 <- ggplot(gap_filtered) +
   aes(x=lifeExp, y=gdpPercap,
       size=pop/100000, color=continent) +
   geom_point() +
   theme_bw() +
   scale_y_continuous(trans = "sqrt") +
   facet_wrap(~year,nrow=1) +
   labs(x="Life Expectancy",
        y="GDP per capita",
        size="Population (100k)",
        color="Continent")
p1

# plot 2
gapminder_continent <- gap_filtered %>%
   group_by(continent, year) %>%
   summarize(gdpPercapweighted = weighted.mean(x = gdpPercap, w = pop),
           pop = sum(as.numeric(pop)))
# firstly, plot from the original gapminder dataset
p_original <- ggplot(data=gap_filtered,
             aes(x=year, y=gdpPercap,
                 size=pop/10000, color=continent)) +
  geom_point() +
  geom_line(aes(group=country), size=0.5) +
  theme_bw() +
  scale_size_continuous(breaks=c(10000,20000,30000)) +
  facet_wrap(~continent, nrow=1) +
  labs(x="Year",
       y="GDP per capita",
       size="Population (100k)",
       color="Continent")
# Secondly, add the data summarized by continents to the plot
p2 <- p_original + geom_point(data=gapminder_continent,
               aes(x=year, y=gdpPercapweighted),
               color="black") +
  geom_line(data=gapminder_continent,
            aes(x=year, y=gdpPercapweighted),
            color="black", size=0.5)
p2

path = here("week_03")
png(file=paste(path, "/p1.png", sep=""), width=800, height= 300)
print(p1)
dev.off()
png(file=paste(path, "/p2.png", sep=""), width=800, height= 250)
print(p2)
dev.off()
