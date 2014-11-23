## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load necessary libraries
library(ggplot2)

## Function to get totals for any Pollutant set given
getAnnualPollutant <- function(NEI, yearWanted) {
	sum(subset(NEI, year == yearWanted)$Emissions)
}

## Initialize the final output variable
processedTable <- data.frame()
## To save processing power/time, subset here instead of loop
baltimore <- subset(NEI, fips == "24510")

## Iterate over every year of subsetted data (and subset again) and create new table
for(eachYear in unique(baltimore$year)){
	for(eachType in unique(baltimore$type)) {
		processedTable <- rbind( processedTable, cbind(eachYear, eachType, getAnnualPollutant(subset(baltimore, type == eachType), eachYear)) )
	}
}

## Provide descriptive names to columns
colnames(processedTable) <- c("year", "type", "totalPollutant")

## Generate graph
png(filename = "plot3.png", bg = "transparent");
qplot(year, as.numeric(as.character(totalPollutant)), data = processedTable, 
	color = type, group = type, geom = "smooth", 
	xlab = "Year", ylab = "Total Emissions (in tons)", main = "Annual Emissions in Baltimore")
dev.off()