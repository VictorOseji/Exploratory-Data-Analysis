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


#####################################################
## Chart 3
#####################################################
data <- power_data %>% 
  mutate(Datetime = as.POSIXct(paste(Date,Time),format = '%Y-%m-%d %H:%M:%S'))

# Plot Sub_metering_1 as the base plot
with(data,
     plot(Datetime,Sub_metering_1,
          type = 'l', # Adjust bin size
          main = "",
          ylab = "Energy Sub Metering",
          xlab = "",
          col = "#373737",
          xaxt = 'n') # Suppress default y-axis
)

# Add Sub_metering_2 and Sub_metering_3 to the same plot
lines(data$Datetime, data$Sub_metering_2, col = "red")    # Sub_metering_2 in red
lines(data$Datetime, data$Sub_metering_3, col = "blue")   # Sub_metering_3 in blue

# Add a legend at the top right
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1, # Line types for the legend
       cex = 0.8, # Adjust size of the legend
) 

axis(1, at = seq(min(data$Datetime), max(data$Datetime), by = "day"),
     labels = format(seq(min(data$Datetime), max(data$Datetime), by = "day"), "%a"),
     las = 1) # Rotate labels vertically if needed
