#!/usr/bin/env bash

function readme {
cat <<EOF
Usage: $BASH_SOURCE -f logfilename -s searchstring

or configure settings in .logconfig file:
filename="logfilename"
searchstring="string to search"

Command line variables will overwrite config file variables.
EOF
exit 1
}

# Loading variables from config file
if [ -f .logconfig ]; then 
	source .logconfig
fi

# Setting variables from command line
while getopts f:s: flag
do
	case "${flag}" in
		f) filename=${OPTARG};;
		s) searchstring=${OPTARG};;
	esac
done

# Checking that variables not empty
(test -z "$filename" || test -z "$searchstring") && readme

# Checking logfile exists
if [ ! -e $filename ]; then
	echo "$filename is not exists" 
       	exit 1
fi

while read line; do
	timestamp=$(echo $line | cut -d ' ' -f 1,2,3)
	nodename=$(echo $line | cut -d ' ' -f 4)
	servicename=$(echo $line | cut -d ' ' -f 5 | cut -d '-' -f 2 | cut -d ':' -f 1)
	logstring=$(echo $line | cut -d ' ' -f 6-)
	#echo $timestamp
	#echo $nodename
	#echo $servicename
	#echo $logstring
	echo "$logstring" | grep "$searchstring"
	if [ $? -eq "0" ]; then
		echo Restarting $servicename
		systemctl restart backend@$servicename.service
	fi
done < <(tail -n 0 -F $filename)

