trend_monitor <- function(in_args) {
	require(timeSeries)

	# read in params
	tsVals <- in_args['prices'][[1]]
	tsDates <- in_args['dates'][[1]]
	period <- in_args['period'][[1]]

	ts <- timeSeries(data=tsVals, charvec=as.Date(tsDates))

	return(list(ts*period, period*period))
}
