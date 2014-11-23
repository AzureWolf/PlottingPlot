## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

library(ggplot2)
getAnnualPollutant <- function(NEI, yearWanted) {
	sum(subset(NEI, year == yearWanted)$Emissions)
}

processedTable <- data.frame()
baltimore <- subset(NEI, fips == "24510")

for(eachYear in unique(baltimore$year)){
	for(eachType in unique(baltimore$type)) {
		processedTable <- rbind( processedTable, cbind(eachYear, eachType, getAnnualPollutant(subset(baltimore, type == eachType), eachYear)) )
	}
}

colnames(processedTable) <- c("year", "type", "totalPollutant")

png(filename = "plot3.png", bg = "transparent");
qplot(year, as.numeric(as.character(totalPollutant)), data = processedTable, 
	color = type, group = type, geom = "smooth", 
	xlab = "Year", ylab = "Total Emissions (in tons)", main = "Annual Emissions in Baltimore")
dev.off()