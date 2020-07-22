BEGIN {
	print "Summary of IPs have come from: \n \n"
	intDF=": "
	outDb="/usr/lib/fail2report/.unban.db"
	outSummary="/usr/lib/fail2report/.unban.summary"
}
/Unban/{
	ip[$NF] ++
        cmd = "geoiplookup "$NF	
	cmd | getline outresult
	close(cmd)
	split(outresult, fromOut, ": ", seps)
	split(fromOut[2], tmpOut, ", ", seps)
	fromCountry=tmpOut[2]
	fromCode=tmpOut[1]
  	fcArray[fromCountry] ++	
	ipCountry[$NF]=fromCountry
}
END {
	for (i in ip){
		printf "%-15s from %-20s has been unbanned: %-6s times\n", i, ipCountry[i], ip[i] > outDb
		}

	asorti(fcArray,fcSorted)
	printf "" > outSummary
	for (fc in fcSorted){
#		printf "IPs from %-20s  were unbanned: %-6s times\n", fcSorted[fc], fcArray[fcSorted[fc]] > outSummary
		printf "unban, %-20s, %-6s \n", fcSorted[fc], fcArray[fcSorted[fc]] >> outSummary
	}
}
