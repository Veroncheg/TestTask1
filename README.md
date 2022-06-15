# TestTask1
Files:
- .logconfig - example config file
- testlog - test log file with log strings
- testlog.service - systemd unit
- testlog.sh - bash daemon
- testlog.yml - CloudFormation template
- userdata.sh - Userdata for EC2 instance to setup daemon

By default this cf template will create ec2 instance in new vpc, internet gateway in this vpc, iam role for ec2 instance for ssm connectivity.
To connect to the instance, use ssm session.
By default daemon will check /var/log/testlog file for "TimeoutError" errors. This is configured in systemd unit file.

Running manually: 
testlog.sh -c configfile -f logfilename -s searchstring

Configuration file format:
filename="logfilename"
searchstring="string to search"

Command line variables will overwrite config file variables.
