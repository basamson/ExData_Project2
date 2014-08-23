# 5. How have emissions from motor vehicle sources changed from 1999–2008 
#    in Baltimore City?

library(reshape2)

# Read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get SCCs of vehicle-related sources
vehicleSources <- SCC[grep("*Vehicle*", SCC$EI.Sector), ]
vehicleSources$SCC <- as.character(vehicleSources$SCC)

# Get emission data for vehicle-related sources in Baltimore
baltimoreVehicleEmissions <- merge(NEI[NEI$fips == 24510, ], 
                                   vehicleSources)

# Reshape data
baltimoreVehicleEmissions <- melt(baltimoreVehicleEmissions,
                                  id = "year", 
                                  measure.vars = "Emissions")
annualBaltimoreVehicleEmissions <- dcast(baltimoreVehicleEmissions,
                                         year ~ variable, 
                                         sum)

# Plot graph
png(filename = "plot5.png", 
    width = 480, 
    height = 480)

plot(annualBaltimoreVehicleEmissions$year,
     annualBaltimoreVehicleEmissions$Emissions,
     main = "Total vehicle-related PM2.5 emissions in Baltimore City",
     pch = 16,
     type = "o",
     xlab = "Year",
     ylab = "PM2.5 emissions")

dev.off()
