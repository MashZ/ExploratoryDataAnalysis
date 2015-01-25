require(ggplot2)

## Load the provided RDS files by following the included directions.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset NEI for Baltimore City, Maryland (fips == "24510")
NEI_BaltCity <- subset(NEI, fips == "24510")
## Subset NEI for Los Angeles (fips == "06037")
NEI_LA <- subset(NEI, fips == "06037")

## Vehicle SCC
SCC_Vehicle <- SCC[grepl("vehicle", SCC$Short.Name, ignore.case = TRUE), ]

## merge the city subsets
NEI_Subset_BC_LA <- as.data.frame(rbind(NEI_BaltCity, NEI_LA))

## Convert year to finite factors to correct ggplot error with "non-finite values (stat_boxplot)" 
NEI_Subset_BC_LA$year <- factor(NEI_Subset_BC_LA$year, levels = c('1999', '2002', '2005', '2008'))

## merge vehicle-related subsets
NEI_Subset_Vehicle <- merge(x = NEI_Subset_BC_LA, y = SCC_Vehicle, by = 'SCC')
NEI_Vehicle <- aggregate(NEI_Subset_Vehicle[, 'Emissions'], by = list(NEI_Subset_Vehicle$year), sum)
colnames(NEI_Vehicle) <- c('Year', 'Emissions')

## Using ggplot to produce the plot, save to a file, then close out. 
# g <- ggplot(data = NEI_Vehicle, aes(x = Year, y = (Emissions / 1000) )) +
#     geom_bar(aes(fill = Year), stat = "identity") + 
#     guides(fill = FALSE) +
#     ylab( expression('PM'[2.5]) ) +
#     xlab('Year') + 
#     ggtitle('Total Emissions of Motor Vehicle Sources\nLos Angeles v Baltimore City') +
#     geom_jitter(alpha = 0.10)

g <- ggplot(data = NEI_Vehicle, aes(x = Year, y = Emissions)) + 
    geom_bar(aes(fill = Year),stat = "identity") + 
    guides(fill = F) + 
    ggtitle('Total Emissions of Vehicle Sources\nLos Angeles v Baltimore City') + 
    ylab(expression('PM'[2.5])) + 
    xlab('Year') + 
    theme(legend.position = 'none') + 
    facet_grid(. ~ fips) + 
    geom_text(aes(label = round(Emissions, 0), size = 1, hjust = 0.5, vjust = -1))
ggsave("plot6.png")
dev.off()