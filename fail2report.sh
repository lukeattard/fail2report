#!/bin/bash


function help {
	printf "fail2report - Quick reporting on the Source of failed logins based on fail2ban logs \n\n"
	printf "usage: fail2report update 		updates the db based on the current fail2ban (/var/log/fail2ban.log)\n"
	printf "or:    fail2report load [log file]  	reloads the database based on the log file entered, if no log file, defaults to /var/log/fail2ban.log \n"
	printf "or:    fail2report full 		Sends to standard out a list of all the IP's, and their origin and a summary of the countries of origin\n"
	printf "or:    fail2report summary 		Sends to standard out a summary of the country of origin\n"
	printf "or:    fail2report iplist 		Sends to standard out a list of all ips that have had a failed login \n"
	printf "or:    fail2report ip [ip address]	ip address 4.2.2.1 must be full address at this point in time \n"
	printf "or:    fail2report country [country]    Country name Must be full name at this point of time \n\n"
	printf "or:    fail2report --help 		This help\n\n"
	printf "Will be adding a basic html page for output to a webserver. \n "

}

function countrysummary {
	
	awk 'BEGIN{ FS=","; } /from/{ fromtime=$2; fromdate=$3 } /to/{ totime=$2; todate=$3 } END{ printf "Report from %s, %s to %s, %s \n\n", fromtime, fromdate, totime, todate }' /usr/lib/fail2report/.reporttimes 
	printf "Summary of IPs by Country: \n\n"
	awk 'BEGIN { FS = ","; } /banip/{	coo[$2]["Country"] = $2; coo[$2]["banip"] = $3 }
			   /foundip/{   coo[$2]["Country"] = $2; coo[$2]["foundip"] = $3 }
			   /unban/{   coo[$2]["Country"] = $2; coo[$2]["unban"] = $3 }
	     END {
			for (i in coo) {
				printf "IPs from %-20s have attempted: %-6s been banned: %-6s and unbanned: %-6s \n", coo[i]["Country"], coo[i]["foundip"], coo[i]["banip"], coo[i]["unban"]
			}
		}' /usr/lib/fail2report/.*.summary  

}

function ipsummary {
	
	awk 'BEGIN{ FS=","; } /from/{ fromtime=$2; fromdate=$3 } /to/{ totime=$2; todate=$3 } END{ printf "Report from %s, %s to %s, %s \n\n", fromtime, fromdate, totime, todate }' /usr/lib/fail2report/.reporttimes 
	printf "List of all IP that have had a failed login attempt in the current log file loaded:\n\n"
	awk 'BEGIN { FS = ","; } /banip/{	coo[$2]["IP"] = $2; coo[$2]["Country"] = $3; coo[$2]["banip"] = $4 }
			   /foundip/{   coo[$2]["IP"] = $2; ccoo[$2]["Country"] = $3; coo[$2]["foundip"] = $4 }
			   /unban/{   coo[$2]["IP"] = $2; ccoo[$2]["Country"] = $3; coo[$2]["unban"] = $4 }
	     END {
			for (i in coo) {
				printf "IP %-15s from %-20s have attempted: %-6s been banned: %-6s and unbanned: %-6s \n", coo[i]["IP"], coo[i]["Country"], coo[i]["foundip"], coo[i]["banip"], coo[i]["unban"]
			}
		}' /usr/lib/fail2report/.*.db
}

banipdb='/usr/lib/fail2report/.banip.db'
foundipdb='/usr/lib/fail2report/.foundip.db'
unbanipdb='/usr/lib/fail2report/.unbanip.db'

if [[ $1 == 'update' ]]; then
	printf "Updating database from the current log file.  Please wait \n"
	awk -f /usr/lib/fail2report/BanIP.awk /var/log/fail2ban.log > /usr/lib/fail2report/.banip.db &
	awk -f /usr/lib/fail2report/FoundIP.awk /var/log/fail2ban.log > /usr/lib/fail2report/.foundip.db &
	awk -f /usr/lib/fail2report/UnbanIP.awk /var/log/fail2ban.log > /usr/lib/fail2report/.unbanip.db &
	wait
	printf "Database updated with the current log of fail2ban\n\n"

elif [[ $1 == 'load' ]]; then
	if [[ -z "$2" ]]; then
		ARG2="/var/log/fail2ban.log"
	else
		ARG2=$2
	fi 
	printf "Updating database from %s.  Please wait \n" $ARG2
	awk -f /usr/lib/fail2report/BanIP.awk $ARG2 > /usr/lib/fail2report/.banip.db &
	awk -f /usr/lib/fail2report/FoundIP.awk $ARG2 > /usr/lib/fail2report/.foundip.db &
	awk -f /usr/lib/fail2report/UnbanIP.awk $ARG2 > /usr/lib/fail2report/.unbanip.db &
	wait
	printf "Database updated from log %s\n\n" $ARG2

elif [[ $1 == 'full' ]]; then

	printf "Full Report:  \n\n"
	ipsummary
	countrysummary
	
elif [[ $1 == 'iplist' ]]; then

	ipsummary 

elif [[ $1 == 'summary' ]]; then

	countrysummary
	 
elif [[ $1 == 'ip' ]]; then 

	from=$(grep $2 $foundipdb | grep -o -P '(?<=from).*(?=has:)')
	printf "%s from %s has: \n\n" $2 $from
	grep $2 $foundipdb | awk 'BEGIN{ FS=":"; } { printf "%.4s attempts where no actions was taken \n", $2}'
	grep $2 $banipdb | awk 'BEGIN{ FS=":"; } { printf "%.4s attempts resulted in a ban \n", $2}'
	grep $2 $unbanipdb | awk 'BEGIN{ FS=":"; } { printf "%.4s times the ip was unabnned \n", $2}'

elif [[ $1 == 'country' ]]; then

	grep $2 $foundipdb
	grep $2 $banipdb
	grep $2 $unbanipdb

elif [[ $1 == '--help' ]]; then

	help

else

	help
fi




