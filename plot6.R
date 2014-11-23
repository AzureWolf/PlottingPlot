## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Load necessary libraries
library(ggplot2)

## Function to get totals for any Pollutant set given
getAnnualPollutant <- function(NEI, yearWanted) {
	sum(subset(NEI, year == yearWanted)$Emissions)
}

## Function to filter data based on source (provided as a Regular Expression)
getSources <- function(SCC, sourceWanted) {
	subset(SCC, grepl(sourceWanted, EI.Sector))$SCC
}
## Find motor vehicles sources
vehicularSources <- getSources(SCC, "On-Road.*Vehicles")
## Initialize the final output variable
processedTable <- data.frame()

## To save processing power/time, get subsets here instead of loop
baltimore <- subset(NEI, fips == "24510" & type == "ON-ROAD")
losAngeles <- subset(NEI, fips == "06037" & type == "ON-ROAD")

## Iterate over every year of subsetted Baltimore data (and subset again) and create new table
for(eachYear in unique(baltimore$year)) {
	processedTable <- rbind( processedTable, cbind("Baltimore", eachYear, getAnnualPollutant(subset(baltimore, SCC %in% vehicularSources), eachYear)) )
}

## Iterate over every year of subsetted Los Angeles data (and subset again) and create new table
for(eachYear in unique(losAngeles$year)) {
	processedTable <- rbind( processedTable, cbind("Los Angeles", eachYear, getAnnualPollutant(subset(losAngeles, SCC %in% vehicularSources), eachYear)) )
}
## Provide descriptive names to columns
colnames(processedTable) <- c("city", "year", "totalPollutant")

## Generate graph
png(filename = "plot6.png", bg = "transparent")
qplot(year, as.numeric(as.character(totalPollutant)), data = processedTable, 
	color = city, group = city, geom = "smooth",
	xlab = "Year", ylab = "Total Emissions (in tons)", main = "Motor Vehicle Emissions (Baltimore vs Los Angeles)")
dev.off()