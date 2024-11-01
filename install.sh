#!/bin/bash
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

cp ${SCRIPTPATH}/fail2report.sh /usr/bin/fail2report
chmod 711 /usr/bin/fail2report
mkdir /usr/lib/fail2report 2> /dev/null
cp ${SCRIPTPATH}/*.awk /usr/lib/fail2report/

printf "Installing geoip-bin\n\n"
apt install geoip-bin

printf "fail2report is now installed run fail2report --help for help\n\n"
