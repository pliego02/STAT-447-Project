## ----setup, include=FALSE--------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
#if you do not have the package, type install.packages("name_of_the_package")
library(knitr)
library(tseries)
library(readxl)
library(dplyr)


## ----echo=TRUE, message=FALSE, warning=FALSE-------------------------------------------------------------------------------------------------------------
# I will make a function here that I can call from from somewhere else to get
# The data

get_dataset <- function() {
# First sample
data_cracks_1 <- read_excel("/Users/pliego/Downloads/HC05_crack_seal_statistics_optical ms.xlsx",
                          skip = 1, sheet = 'Profile 1')

thickness_values_1 <- data_cracks_1$`thickness (um)`

thickness_values_1 <- thickness_values_1[1:(length(thickness_values_1) - 3)]



# Second sample
data_cracks_2 <- read_excel("/Users/pliego/Downloads/HC05_crack_seal_statistics_optical ms.xlsx",
                            sheet = 'Profiles 2, 3, 4, 5')

thickness_values_2 <- na.omit(data_cracks_2$Thickness)

# Third sample
data_cracks_3_1 <- read_excel("/Users/pliego/Downloads/HC05_crack_seal_statistics_optical ms.xlsx",
                            sheet = 'Profile 6', skip = 2)

data_cracks_3_2 <- read_excel("/Users/pliego/Downloads/HC05_crack_seal_statistics_optical ms.xlsx",
                            sheet = 'Profile 7', skip = 2)

thickness_values_3_1 <-  na.omit(data_cracks_3_1$thickness)

thickness_values_3_2 <-  na.omit(data_cracks_3_2$Thickness)


thickness_values_3 <- c(thickness_values_3_1, thickness_values_3_2)




# Fourth sample
data_cracks_4 <- read_excel("/Users/pliego/Downloads/HC05_crack_seal_statistics_optical ms.xlsx",
                            sheet = 'Profile 8', skip = 2)

thickness_values_4 <- na.omit(data_cracks_4$Thickness)

# Fifth sample
data_cracks_5 <- read_excel("/Users/pliego/Downloads/HC05_crack_seal_statistics_optical ms.xlsx",
                            sheet = 'Profile 9', skip = 2)

thickness_values_5 <- na.omit(data_cracks_5$Thickness)


# Sixth sample
data_cracks_6 <- read_excel("/Users/pliego/Downloads/HC05_crack_seal_statistics_optical ms.xlsx",
                            sheet = 'Profile 10', skip = 2)

thickness_values_6 <- na.omit(data_cracks_6$Thickness)


## Now we merge everything into a single dataset and label them by sample

thickness_data <- data.frame(
  Thickness = c(thickness_values_1, thickness_values_2, thickness_values_3,
                thickness_values_4, thickness_values_5, thickness_values_6),
  Sample = c(rep(1, length(thickness_values_1)),
             rep(2, length(thickness_values_2)),
             rep(3, length(thickness_values_3)),
             rep(4, length(thickness_values_4)),
             rep(5, length(thickness_values_5)),
             rep(6, length(thickness_values_6)))
)

return(thickness_data)
}



## ----echo=TRUE, fig.height=12, fig.width=8---------------------------------------------------------------------------------------------------------------
#Adjust plots
par(mfrow=c(3,2), mar=c(4,4,2,1)) 

thickness_data <- get_dataset()

# Create a list of time series for each sample
samples <- 1:6
ts_list <- lapply(samples,
                  function(i) ts(thickness_data$Thickness[thickness_data$Sample == i]))

# Plot each time series
for (i in seq_along(ts_list)) {
  plot(ts_list[[i]], main=paste("Sample", samples[i], "Plot"),
       ylab="Thickness", xlab="Index",lwd=2)
}




## ----echo=TRUE, fig.height=12, fig.width=8---------------------------------------------------------------------------------------------------------------
#Adjust plots
par(mfrow=c(3,2), mar=c(4,4,2,1)) 



# Generate correlograms for each sample
for (i in seq_along(ts_list)) {
  acf(ts_list[[i]], main=paste("Sample", samples[i], "Correlogram"), lwd=2)
}



