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

## Find "COMBUSTIBLE" "COAL" sources only
coalCombustionSources <- getSources(SCC, "Fuel Comb.*Coal")
## Initialize the final output variable
processedTable <- data.frame()

## Iterate over every year and create new table
for(eachYear in unique(NEI$year)) {
	processedTable <- rbind( processedTable, cbind(eachYear, getAnnualPollutant(subset(NEI, SCC %in% coalCombustionSources), eachYear)) )
}

## Provide descriptive names to columns
colnames(processedTable) <- c("year", "totalPollutant")

## Generate graph
png(filename = "plot4.png", bg = "transparent");
plot(processedTable[,1], processedTable[,2], type="b", ylab = "Total Emissions (in tons)", xlab = "Year", main = "Annual Emissions in US by Coal Combusion")
dev.off()