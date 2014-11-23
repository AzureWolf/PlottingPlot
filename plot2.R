## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

getAnnualPollutant <- function(NEI, yearWanted) {
	sum(subset(NEI, year == yearWanted)$Emissions)
}

processedTable <- data.frame()
for(eachYear in unique(NEI$year)){
	processedTable <- rbind( processedTable, cbind(eachYear, getAnnualPollutant(subset(NEI, fips == "24510"), eachYear)) )
}

png(filename = "plot2.png", bg = "transparent");
plot(processedTable[,1], processedTable[,2], type="b", ylab = "Total Emissions (in tons)", xlab = "Year", main = "Annual Emissions in Baltimore")
dev.off()