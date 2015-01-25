require(ggplot2)

## Load the provided RDS files by following the included directions.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset NEI for Baltimore City, Maryland (fips == "24510")
NEI_BaltCity <- subset(NEI, fips == "24510")

## Convert year to finite factors to correct ggplot error with "non-finite values (stat_boxplot)" 
NEI_BaltCity$year <- factor(NEI_BaltCity$year, levels = c('1999', '2002', '2005', '2008'))

## Vehicle SCC
SCC_Vehicle <- SCC[grepl("vehicle", SCC$Short.Name, ignore.case = TRUE), ]

## merge coal-related subsets from NEI_BaltCity for Baltimore City only
NEI_Subset_Vehicle <- merge(x = NEI_BaltCity, y = SCC_Vehicle, by = 'SCC')
NEI_Balt_Vehicle <- aggregate(NEI_Subset_Vehicle[, 'Emissions'], by = list(NEI_Subset_Vehicle$year), sum)
colnames(NEI_Balt_Vehicle) <- c('Year', 'Emissions')

## Using ggplot to produce the plot, save to a file, then close out. 
g <- ggplot(data = NEI_Balt_Vehicle, aes(x = Year, y = (Emissions / 1000) )) +
    geom_line(aes(group = 1, col = Emissions)) +
    geom_point(aes(size = 2, col = Emissions)) +
    geom_text(aes(label = round(Emissions/1000, digits=2), size=2, hjust=1.5, vjust=1.5)) +
    ylab( expression(paste('PM', ''[2.5], ' in Kilotons')) ) +
    xlab('Year') + 
    ggtitle(expression('Baltimore City Maryland Vehicular Emissions of PM'[2.5])) +
    geom_jitter(alpha = 0.10)

ggsave("plot5.png")
dev.off()