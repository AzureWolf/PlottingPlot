## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
getAnnualPollutant <- function(NEI, yearWanted) {
	sum(subset(NEI, year == yearWanted)$Emissions)
}

getSources <- function(SCC, sourceWanted) {
	subset(SCC, grepl(sourceWanted, EI.Sector))$SCC
}

coalCombustionSources <- getSources(SCC, "Fuel Comb.*Coal")
processedTable <- data.frame()

for(eachYear in unique(NEI$year)) {
	processedTable <- rbind( processedTable, cbind(eachYear, getAnnualPollutant(subset(NEI, SCC == coalCombustionSources), eachYear)) )
}

colnames(processedTable) <- c("year", "totalPollutant")
plot(processedTable[,1], processedTable[,2], type="l")