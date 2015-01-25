## Load the provided RDS files by following the included directions.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

emissions <- aggregate(NEI[, 'Emissions'], by = list(NEI$year), FUN = sum)

## Plot requires discrete values, and use this opportunity to convert from tons to Kilotons.
emissions$PM <- round(emissions[, 2] / 1000, 2)

## Open graphics device to produce the plot, save to a file, then close out. 
png(filename = "plot1.png")
barplot(emissions$PM, names.arg = emissions$Group.1, 
        main = expression('Total Emissions of PM'[2.5]), 
        xlab = 'Year', ylab = expression(paste('PM', ''[2.5], ' in Kilotons')))
dev.off()
