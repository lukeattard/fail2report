BEGIN {
	intDF=": "
	outDb = "/usr/lib/fail2report/.banip.db"
	outSummary = "/usr/lib/fail2report/.banip.summary"
}
/Ban/{
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
	print "Summary of Country of origin for failed login attempts: \n \n" > outDb
	for (i in ip){
		printf "%-15s from %-20s has been banned: %-6s times\n", i, ipCountry[i], ip[i] >> outDb 
		}
	close(outDb)
	print "\n \n Summary of Countries have come from: \n \n" > outSummary
	asorti(fcArray,fcSorted)
	for (fc in fcSorted){
#		printf "IP Addresses from %-20s  were banned: %-6s times\n", fcSorted[fc], fcArray[fcSorted[fc]] >> outSummary
		printf "banip, %-20s, %-6s\n", fcSorted[fc], fcArray[fcSorted[fc]] >> outSummary
	}
	close(outSumary)
}
