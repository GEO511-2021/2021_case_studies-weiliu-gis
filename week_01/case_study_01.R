# Case 1: Your first script
#-----------------------------------------
# Wei Liu
# 09/04/2021, updated on 09/08/2021
#-----------------------------------------

library("ggplot2")

data(iris)

# Explore the structure of the data
str(iris)

### statistical charateristics

# [1] mean(), median(), sd()
len = iris$Petal.Length
petal_length_mean = mean(len)
petal_length_median = median(len)
petal_length_stdev = sd(len)

# [2] summary
summary_iris = summary(iris)
summary_iris
summary_len = summary(len)
summary_len

### THREE methods to get our plot

# [1] plot using hist() and save it
png(file="C:/CodeProjects/GEO511/case_1/plots/petal_length_hist_1.png",
    width=500, height= 400)
hist(len,
     col="purple", border="white",
     main="Distribution of the Petal Length",
     xlab="Petal Length",
     ylab="Count")
dev.off()

# [2] plot using ggplot() and save it
myplot <- ggplot(iris, aes(x=len, fill=Species)) +
  geom_histogram(bins=10L, position="stack",
                 color="white", alpha=0.8) + 
  labs(
    title="Distribution of the Petal Length",
    y = "Count",
    x = "Petal Length"
  ) +
  theme_linedraw() +
  theme(plot.title = element_text(size = 16L, face = "bold",
                                  hjust = 0.5))
myplot

png(file="C:\\CodeProjects\\GEO511\\case_1\\plots\\petal_length_hist_2.png",
    width=500, height= 400)
print(myplot)
dev.off()

# [3] plot using esquisse package
#esquisse::esquisser()