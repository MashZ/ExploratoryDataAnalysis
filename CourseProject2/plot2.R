## Load the provided RDS files by following the included directions.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset NEI for Baltimore City, Maryland (fips == "24510")
NEI_BaltCity <- subset(NEI, fips == "24510")

## Open graphics device to produce the plot, save to a file, then close out. 
png(filename = "plot2.png")
barplot(tapply(X = NEI_BaltCity$Emissions, INDEX = NEI_BaltCity$year, FUN = sum), 
        main = 'Emmissions in Baltimore City, Maryland', 
        xlab = 'Year', ylab = expression(paste('PM', ''[2.5], ' in tons')))
dev.off()
