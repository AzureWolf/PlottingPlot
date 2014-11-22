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

coalCombustionSources <- getSources(SCC, "On-Road.*Vehicles")
processedTable <- data.frame()
baltimore <- subset(NEI, fips == "24510" & type == "ON-ROAD")
losAngeles <- subset(NEI, fips == "06037" & type == "ON-ROAD")

for(eachYear in unique(baltimore$year)) {
	processedTable <- rbind( processedTable, cbind(eachYear, getAnnualPollutant(subset(baltimore, SCC %in% coalCombustionSources), eachYear)) )
}

for(eachYear in unique(baltimore$year)) {
	processedTable <- rbind( processedTable, cbind(eachYear, getAnnualPollutant(subset(baltimore, SCC %in% coalCombustionSources), eachYear)) )
}

colnames(processedTable) <- c("year", "totalPollutant")
qplot()