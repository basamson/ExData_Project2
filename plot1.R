# 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

#check if files exists
if(!file.exists("summarySCC_PM25.rds") && 
           !file.exists("Source_Classification_Code.rds")) {
        
        #download the file
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                      destfile="data.zip", 
                      method="auto")
        
        #unzip the contents of zipfile
        unzip("data.zip")
}        

# Read data files
NEI <- readRDS("summarySCC_PM25.rds")

total.emissions <- aggregate(Emissions ~ year, NEI, sum)

png('plot1.png')
barplot(height=total.emissions$Emissions, names.arg=total.emissions$year,
        xlab="years", ylab=expression('Total PM'[2]*' Emissions'),
        main=expression('Total PM'[2]*' Emissions by Year'))
dev.off()
