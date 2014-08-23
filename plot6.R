# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions 
#    from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#    Which city has seen greater changes over time in motor vehicle emissions?

library(ggplot2)

# Read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset emissions for Baltimore City and Los Angeles Counties
sub <- NEI[NEI$fips %in% c("24510", "06037"), ]

# Combine the emissions subset with the Source Classification Code Table on the SCC column
merged <- merge(sub, SCC)

# Identify Mobile Sources and motor vehicle sources. Significant help from the 
# forums helped to build this code
mobile.sources <- merged[merged$SCC.Level.One == "Mobile Sources", ]
motor.vehicle.sources <- mobile.sources[grepl("(highway|LPG)", 
                                              mobile.sources$SCC.Level.Two, 
                                              ignore.case=T, 
                                              perl=T), ]
motor.vehicle.sources <- motor.vehicle.sources[!grepl("equipment", 
                                                      motor.vehicle.sources$SCC.Level.Three, 
                                                      ignore.case=T, 
                                                      perl=T), ]

# Add a factor column for the county name
locations <- c("Baltimore City"="24510", 
               "Los Angeles County"="06037")
ind <- match(motor.vehicle.sources$fips, 
             locations)
motor.vehicle.sources$location <- as.factor(names(locations)[ind])

# Aggregate the total emissions from motor vehicle sources by year and county
summary <- ddply(motor.vehicle.sources, 
                 .(year, location), 
                 summarize, 
                 total.emissions=sum(Emissions))

# Output the plot to a PNG file
png(file="plot6.png", 
    width = 480, 
    height = 480)

# Plot a multi-panel line chart of the summary data by county
ggplot(summary, aes(year, total.emissions)) +
        geom_line() +
        theme_bw() + 
        guides(fill=FALSE) +
        facet_grid(.~location,
                   scales = "free",
                   space="free") + 
        geom_smooth(method="lm") +
        labs(title="Emissions from motor vehicle sources")

dev.off()
