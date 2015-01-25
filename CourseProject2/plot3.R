## #3 requires ggplot2
require(ggplot2)

## Load the provided RDS files by following the included directions.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset NEI for Baltimore City, Maryland (fips == "24510")
NEI_BaltCity <- subset(NEI, fips == "24510")

## Convert year to finite factors to correct ggplot error with "non-finite values (stat_boxplot)" 
NEI_BaltCity$year <- factor(NEI_BaltCity$year, levels = c('1999', '2002', '2005', '2008'))

## Using ggplot to produce the plot, save to a file, then close out. 
g <- ggplot(data = NEI_BaltCity, aes(x = year, y = log(Emissions))) +
    facet_grid(. ~ type) +
    guides(fill = FALSE) +
    geom_boxplot(aes(fill = type)) + 
    stat_boxplot(geom = 'errorbar') +
    ylab(expression(paste('Log', ' of PM'[2.5], ' Emissions'))) +
    xlab('Year') + 
    ggtitle('Emissions per Type in Baltimore City, Maryland') +
    geom_jitter(alpha = 0.10)

ggsave("plot3.png")
dev.off()
