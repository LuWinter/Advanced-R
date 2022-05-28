
library(assertr)
library(dplyr)

head(mtcars)

our_data <- mtcars
our_data$mpg[5] <- our_data$mpg[5] * -1
head(our_data)

our_data %>% 
  group_by(cyl) %>% 
  summarise(avg_mpg = mean(mpg))
# mtcars %>% 
  # group_by(cyl) %>%
  # summarise(avg_mpg = mean(mpg))

