test.trend_monitor <- function()
{
	library(RUnit)

	dates <- paste(c("2006-12-29","2007-01-01","2007-01-02","2007-01-03","2007-01-04","2007-01-05","2007-01-08","2007-01-09","2007-01-10","2007-01-11"),sep="")
	prices <- c(30.700, 30.700, 31.103, 30.958, 30.621, 30.409, 30.326, 30.521, 29.935, 30.255)
	period <- 40
	result <- trend_monitor(in_args=list(prices=prices, dates=dates, period=period))

	checkEquals(result[[2]], period*period)
}
