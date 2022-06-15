#!/usr/bin/env bash

function readme {
cat <<EOF
Usage: $BASH_SOURCE -c configfile -f logfilename -s searchstring

Configuration file format:
filename="logfilename"
searchstring="string to search"

Command line variables will overwrite config file variables.
EOF
exit 1
}

# Setting variables from command line
while getopts f:s:c: flag
do
	case "${flag}" in
		f) filenamearg=${OPTARG};;
		s) searchstringarg=${OPTARG};;
		c) configfile=${OPTARG};;
	esac
done

# Loading variables from config file
if [ -f "$configfile" ]; then 
	source "$configfile"
fi

#Overriding variables from configfile with variables from command line
test -z "$filenamearg" || filename=$filenamearg
test -z "$searchstringarg" || searchstring=$searchstringarg

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

