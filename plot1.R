######################################################################
##====================================================================
# Load necessary library
# Install required packages if not already installed
if (!require("data.table")) install.packages("data.table")
if (!require("dplyr")) install.packages("dplyr")

library(dplyr)

# Step 1: Download and unzip dataset
# Define the URL for downloading the dataset
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download_power <- "power_consumer.zip"

if (!file.exists(download_power)) {
  download.file(url, download_power)
}

if (!file.exists("household_power_consumption.txt")) {
  unzip(download_power)
}

# Load dataset
power_data <- read.table("household_power_consumption.txt",header = TRUE, sep = ';') %>% 
  mutate(Date = as.Date(Date, format = '%d/%m/%Y'),
         Time = data.table::as.ITime(Time)) %>% 
  filter(between(Date,as.Date('2007-02-01'),as.Date('2007-02-02'))) %>% 
  mutate(across(where(is.character),as.numeric))

###############################################################
## Chart 1 
###############################################################
# Plot the histogram
with(power_data,
     hist(Global_active_power,
     breaks = 20, # Adjust bin size
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency",
     col = "red",
     xlim = c(0,6),
     ylim = c(0,1200),
     xaxt = "n", # Suppress default x-axis
     yaxt = "n") # Suppress default y-axis
)
# Customize x-axis ticks (interval of 2)
axis(1, at = seq(0, max(power_data$Global_active_power, na.rm = TRUE), by = 2), tck = -0.025)

# Customize y-axis ticks (interval of 200)
axis(2, at = seq(0, max(hist(power_data$Global_active_power, plot = FALSE)$counts), by = 200), tck = -0.025)









