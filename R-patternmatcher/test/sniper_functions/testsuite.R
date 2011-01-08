source('../src/sniper_functions/R/function_trend_monitor.r')

library(RUnit)
#ro <- getOption("RUnit")
#ro$silent <- TRUE
#ro$verbose <- OL
#options("RUnit"= ro)
testsuite <- defineTestSuite(name= "TestSuiteSniperFunctions",
	dirs= "sniper_functions",
	testFileRegexp= "runit.+\\.r",
	testFuncRegexp= "test.+",
	rngKind= "Marsaglia-Multicarry",
	rngNormalKind= "Kinderman-Ramage")

testResult <- runTestSuite(testsuite)
getErrors(testResult)
#printTextProtocol(testResult)
