require(ggplot2)

## Load the provided RDS files by following the included directions.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Coal SCC
SCC_Coal <- SCC[grepl("coal", SCC$Short.Name, ignore.case = TRUE), ]

## merge coal-related subsets from the complete datasets
NEI_Subset_Coal <- merge(x = NEI, y = SCC_Coal, by = 'SCC')
NEI_Coal <- aggregate(NEI_Subset_Coal[, 'Emissions'], by = list(NEI_Subset_Coal$year), sum)
colnames(NEI_Coal) <- c('Year', 'Emissions')

## Using ggplot to produce the plot, save to a file, then close out. 
g <- ggplot(data = NEI_Coal, aes(x = Year, y = (Emissions / 1000) )) +
    geom_line(aes(group = 1, col = Emissions)) +
    geom_point(aes(size = 2, col = Emissions)) +
    geom_text(aes(label = round(Emissions/1000, digits=2), size=2, hjust=1.5, vjust=1.5)) +
    ylab( expression(paste('PM', ''[2.5], ' in Kilotons')) ) +
    xlab('Year') + 
    ggtitle(expression('Total Emissions of PM'[2.5])) +
    geom_jitter(alpha = 0.10)

ggsave("plot4.png")
dev.off()