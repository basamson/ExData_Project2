# 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
#    (fips == "24510") from 1999 to 2008? Use the base plotting system to make 
#    a plot answering this question

library(plyr)

# Load data
NEI <- readRDS("summarySCC_PM25.rds")

data<-transform(NEI,
                year=factor(year))
data<-data[data$fips=="24510",]

#Plot Data
plotdata<-ddply(data,
                .(year),
                summarize,
                sum=sum(Emissions))

png("plot2.png")
plot(plotdata$year,
     plotdata$sum,
     type="n",
     xlab="year",
     ylab="total PM2.5 Emission",
     main="PM2.5 emission in Baltimore City",
     boxwex=0.05)
lines(plotdata$year,plotdata$sum)
dev.off()
