if (!file.exists("household_power_consumption.txt")){
	if (!file.exists("exdata-data-household_power_consumption.zip")){
		download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "exdata-data-household_power_consumption.zip", method = "curl")
	}
	unzip("exdata-data-household_power_consumption.zip")
	}

source <- file("household_power_consumption.txt", open = "r")
line1 <- readLines(source, n=1)
headings <- unlist(strsplit(line1, ";"))
close(source)

setClass('myDate')
setAs("character","myDate", function(from) {as.Date(from, format="%d/%m/%Y")})

data <- read.csv("household_power_consumption.txt", sep = ";", nrows = 2880, na.strings = "?", skip = 66636, col.names = headings, colClasses = c("myDate", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

for (i in 1:length(data$Time)) {data$Time[i] <- paste(data$Date[i], data$Time[i], sep = " ")}

data$Time <- as.POSIXct(data$Time, format = "%Y-%m-%d %H:%M:%S", tz = "GMT")

png(file = "plot4.png")

par(mfrow = c(2, 2))

with(data, {
	plot(Time, Global_active_power, type = "l", main = "", xlab = "", ylab = "Global Active Power")
	
	plot(Time, Voltage, type = "l", main = "", xlab = "datetime")
	
	plot(Time, Sub_metering_1, type = "l", main = "", xlab = "", ylab = "Energy sub metering")
	lines(Time, Sub_metering_2, col = "red")
	lines(Time, Sub_metering_3, col = "blue")
	legend("topright", lwd=1, col = c("black", "red", "blue"), legend = names(data)[7:9], bty = "n")
	
	plot(Time, Global_reactive_power, type = "l", main = "", xlab = "datetime")
	})

dev.off()
