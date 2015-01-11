# Use grep to search, then read data for only the selected dates
reqData <- fread('grep "^[12]/2/2007" ./household_power_consumption.txt', na.strings=c("?",""))
# add back the headers that are not read by grep
setnames(reqData, colnames(fread("./household_power_consumption.txt", nrows=0)))

# Convert data columns into Data/Time classes in R
reqData$Date <- as.Date(reqData$Date, format = "%d/%m/%Y")

# Combine Date/Time into a single column for ease
reqData$Datetime <- as.POSIXct( paste(as.Date(reqData$Date), reqData$Time, sep = " ") )

# Plot 4 code
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(reqData, {
    plot(Global_active_power ~ Datetime, type = "l", ylab = "Global Active Power", xlab = "")
    
    plot(Voltage ~ Datetime, type = "l", ylab = "Voltage", xlab = "datetime")
    
    plot(Sub_metering_1 ~ Datetime, type = "l", ylab = "Energy sub metering", xlab = "")
    lines(Sub_metering_2  ~ Datetime, col = "Red")
    lines(Sub_metering_3  ~ Datetime, col = "Blue")
    legend( "topright", col = c("black", "red", "blue"), lty = 2, lwd = 3,
            legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
            cex = 0.6, text.width = strwidth("Sub_metering_1    ") )
    
    plot(Global_reactive_power ~ Datetime, type = "l", ylab = "Global_reactive_power", xlab = "datetime")
    })

# Save Image 4 with required dimensions  
dev.copy(png, file = "plot4.png", height = 480, width = 480)
dev.off()
