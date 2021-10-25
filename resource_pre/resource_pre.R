library(ggplot2)
library(gganimate)

# we will start with a static plot
p <- ggplot(iris, aes(x=Petal.Width, y=Petal.Length)) +
  geom_point()
plot(p)

# transition_states()
anim <- p +
  transition_states(Species,
                    transition_length=2,
                    state_length=1)
anim

# ease_aes(), control easing of aesthetics. In other words, it defines how the moves will be like between different stages.
## if setting nothing in this function, the default animation will be built with a linear model

anim +
  ease_aes(y = 'bounce-out') # set special ease for y aesthetic

## bounce models the bouncing of a ball

# There are also some other animation type:
## cubic models a power-of-3 function
## exponential models an exponential function
## elastic models anelastic release of energy
# When deciding the animation type, we also choose certain modifier for the animation