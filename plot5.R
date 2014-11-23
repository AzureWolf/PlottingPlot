## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

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
## To save processing power/time, subset here instead of loop
baltimore <- subset(NEI, fips == "24510" & type == "ON-ROAD")

## Iterate over every year of subsetted data (and subset again) and create new table
for(eachYear in unique(baltimore$year)) {
	processedTable <- rbind( processedTable, cbind(eachYear, getAnnualPollutant(subset(baltimore, SCC %in% vehicularSources), eachYear)) )
}

## Provide descriptive names to columns
colnames(processedTable) <- c("year", "totalPollutant")

## Generate graph
png(filename = "plot5.png", bg = "transparent");
plot(processedTable[,1], processedTable[,2], type="b", ylab = "Total Emissions (in tons)", xlab = "Year", main = "Annual Emissions in Baltimore by Vehicle Emissions")
dev.off()