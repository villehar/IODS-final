
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

#cahnging the variable class of the filter variables to logical
names(raw.data)
cols <- c(13, 17, 19, 20)
raw.data[,cols] <- lapply(raw.data[,cols], function(x) as.logical(raw.data[,cols]))
?lapply
