BEGIN {
	getline
	fromDate = $1
	fromTime = $2
	outDb = "/usr/lib/fail2report/.foundip.db"
	outSummary = "/usr/lib/fail2report/.foundip.summary"
	print "Summary of IP source Countries for failed logon attempts: \n \n"
	intDF=": "
}
/Found/{
	ip[$8] ++
        cmd = "geoiplookup "$8	
	cmd | getline outresult
	close(cmd)
	split(outresult, fromOut, ": ", seps)
	split(fromOut[2], tmpOut, ", ", seps)
	fromCountry=tmpOut[2]
	fromCode=tmpOut[1]
  	fcArray[fromCountry] ++	
	ipCountry[$8]=fromCountry
}
END {
	print "Summary of Country of origin for failed logon attempts: \n \n" > outDb
	printf "Report from %.8s %s to %.8s %s\n\n", fromTime, fromDate, $2, $1 >> outDb
	for (i in ip){
		printf "%-15s from %-20s has: %-6s failed login attempts\n", i, ipCountry[i], ip[i] >> outDb
		}

#	print "\n \n Summary of Countries have come from: \n \n" > outSummary
	printf "from, %.8s, %s \nto, %.8s, %s\n\n", fromTime, fromDate, $2, $1 > "/usr/lib/fail2report/.reporttimes"
	asorti(fcArray,fcSorted)
	printf "" > outSummary
	for (fc in fcSorted){
#		printf "IP Addresses from: %-20s  has %-6s failed login attempts\n", fcSorted[fc], fcArray[fcSorted[fc]] >> outSummary
		printf "foundip, %-20s, %-6s \n", fcSorted[fc], fcArray[fcSorted[fc]] >> outSummary
	}
}
