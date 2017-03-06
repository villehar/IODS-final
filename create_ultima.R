
# Ville Harjunen
# Final assignment
# Wrangling the "ultima" data set 


# Downloading the raw (uncleaned) data 
raw.data <- read.table("Data/raw_ultima.txt", header = TRUE, sep = "\t")

# Inspecting the data structure: 21 variables and 38599 observations (about 585 trials for each of the 66 participants)
str(raw.data)

# removing some duplicated variables
library(dplyr)
raw.data <- select(raw.data, -pp.gender)

# Shortening some of the variable names
names(raw.data)
names(raw.data)[8] <- "emo"
names(raw.data)[9] <- "touch"
names(raw.data)[10] <- "offers"
names(raw.data)[11] <- "Fairness"
names(raw.data)[14] <- "accept"
names(raw.data)[15] <- "Cardiac_OR"
names(raw.data)[20] <- "no_problem"

# Glimpsing the resulting data set
glimpse(raw.data)

#changing the variable class of the binary variables to logical
names(raw.data)
cols <- c(13, 17, 19, 20, 14)
raw.data[,cols] <- raw.data[,cols] == 1
str(raw.data)

head(raw.data)
#Filtering out the trials where the participant was the receiver
resp.data <- filter(raw.data, myrole == "responder")
str(resp.data)

# create a filter for pp's with too many acceptances
##staring with creating a aggregated data set with average acceptances per subject
agg.accept <- aggregate(resp.data, by=list(resp.data$pp), FUN=mean)

##selecting only the pp index and acceptances
agg.accept <- select(agg.accept, pp, accept)

#changing the name of 
names(agg.accept)[2]<-"accept.prop"
str(agg.accept)

resp.data2 <- inner_join(resp.data, agg.accept, by = "pp")
str(resp.data2)

resp.data2 <- mutate(resp.data2, over90 = (accept.prop < .90))
str(resp.data2)

#defining the filtered data set. Participants with too high acceptance rate (90%), who knew the ultimatum game beforehand, and had problems in EEG measurement were removed
#also the trials with very short and long reaction times were removed
resp.data3 <- filter(resp.data2, over90 == TRUE, no_problem == TRUE, notknow_ult == TRUE, RT < 5000, ECGFILT == TRUE)
str(resp.data3)

write.csv(resp.data3, "responder.csv")

library(GGally)
library(tidyr)
library(ggplot2)

# A "block" variable was then created based on the trial variable
resp.data3$Block <-cut(resp.data3$trial, c(1,150,300,450,600))
ggplot(resp.data3, aes(x = RT, col = Block)) + geom_histogram(bins = 100)
m <- glm(accept ~ Fairness + emo + touch, data = resp.data3, family = "binomial")
summary(m)
OR <- coef(m) %>% exp
CI <- confint(m) %>% exp
cbind(OR, CI)

summary(resp.data3)
