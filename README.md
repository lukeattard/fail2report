fail2report

Generates reports for fail2ban form the log files, very quick and easy, mainly focused on Country of origin based on the IP of the failed login attempt.

Prerequisite geoiplookup 

install.sh - installs the script into the /usr/bin/ directory after that you can run fail2report

Usage:

fail2report - Quick reporting on the Source of failed logins based on fail2ban logs

usage: fail2report update               updates the db based on the current fail2ban (/var/log/fail2ban.log)
or:    fail2report load [log file]      reloads the database based on the log file entered, if no log file, defaults to /var/log/fail2ban.log
or:    fail2report full                 Sends to standard out a list of all the IP's, and their origin and a summary of the countries of origin
or:    fail2report summary              Sends to standard out a summary of the country of origin
or:    fail2report iplist               Sends to standard out a list of all ips that have had a failed login
or:    fail2report ip [ip address]      ip address 4.2.2.1 must be full address at this point in time
or:    fail2report country [country]    Country name Must be full name at this point of time

or:    fail2report --help               This help

