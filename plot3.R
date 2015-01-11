# Use grep to search, then read data for only the selected dates
reqData <- fread('grep "^[12]/2/2007" ./household_power_consumption.txt', na.strings=c("?",""))
# add back the headers that are not read by grep
setnames(reqData, colnames(fread("./household_power_consumption.txt", nrows=0)))

# Convert data columns into Data/Time classes in R
reqData$Date <- as.Date(reqData$Date, format = "%d/%m/%Y")

# Combine Date/Time into a single column for ease
reqData$Datetime <- as.POSIXct( paste(as.Date(reqData$Date), reqData$Time, sep = " ") )

# Plot 3 code
with(reqData, {
    plot(Sub_metering_1 ~ Datetime, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")
    lines(Sub_metering_2  ~ Datetime, col = "Red")
    lines(Sub_metering_3  ~ Datetime, col = "Blue")
})
legend( "topright", col = c("black", "red", "blue"), lty = 2, lwd = 3,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       cex = 0.6, text.width = strwidth("Sub_metering_1    ") )

# Save Image 3 with required dimensions  
dev.copy(png, file = "plot3.png", height = 480, width = 480)
dev.off()
