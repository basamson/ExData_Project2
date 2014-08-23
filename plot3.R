# 3. Of the four types of sources indicated by the type 
#    (point, nonpoint, onroad, nonroad) variable, which of these four sources 
#    have seen decreases in emissions from 1999–2008 for Baltimore City? 
#    Which have seen increases in emissions from 1999–2008? Use the ggplot2 
#    plotting system to make a plot answer this question.

library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")

## Dataset for Baltimore city
NEI <- subset(NEI, 
              fips=="24510") 

## Split sum by years and plot
sum_year <- aggregate(Emissions ~ year + type, 
                      data=NEI,
                      sum)

ggplot(sum_year,
       aes(factor(year),Emissions,fill=type)) +
        geom_bar(stat="identity") +
        theme_bw() + 
        guides(fill=FALSE) +
        facet_grid(.~type,
                   scales = "free",
                   space="free") + 
        labs(x="year", 
             y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

dev.copy(png,
         file="plot3.png")
dev.off()
