# 4. Across the United States, how have emissions from coal combustion-related 
#    sources changed from 1999–2008?

library(reshape2)

# Read RDS files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get SCCs of coal combustion-related sources
name <- grep(".*Comb.*Coal*", SCC$Short.Name)
sector <- grep("^Fuel Comb.*Coal*", SCC$EI.Sector)
coalCombustion <- union(name, sector)

# Get emission data for coal combustion-related sources
coalCombustion <- SCC[coalCombustion,]
coalCombustion$SCC <- as.character(coalCombustion$SCC)
coalEmissions <- merge(NEI, coalCombustion)

# Reshape data
coalEmissions <- melt(coalEmissions, 
                      id = "year", 
                      measure.vars = "Emissions")

annualCoalEmissions <- dcast(coalEmissions, 
                             year ~ variable, 
                             sum)

png(filename = "plot4.png", 
    width = 480, 
    height = 480)

plot(annualCoalEmissions$year, 
     annualCoalEmissions$Emissions,
     main = "Total coal combustion-related PM2.5 emissions",
     pch = 16,
     type = "o",
     xlab = "Year",
     ylab = "PM2.5 emissions")

dev.off()