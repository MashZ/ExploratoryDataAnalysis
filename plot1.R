# Use grep to search, then read data for only the selected dates
reqData <- fread('grep "^[12]/2/2007" ./household_power_consumption.txt', na.strings=c("?",""))
# add back the headers that are not read by grep
setnames(reqData, colnames(fread("./household_power_consumption.txt", nrows=0)))

# Convert data columns into Data/Time classes in R
reqData$Date <- as.Date(reqData$Date, format = "%d/%m/%Y")

# Combine Date/Time into a single column for ease
reqData$Datetime <- as.POSIXct( paste(as.Date(reqData$Date), reqData$Time, sep = " ") )

# Plot 1 code
hist(reqData$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "Red")

# Save Image 1 with required dimensions    
dev.copy(png, file = "plot1.png", height = 480, width = 480)
dev.off()
