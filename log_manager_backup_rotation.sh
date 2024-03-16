#! /bin/bash
#



# This is the log manager part

cd /var/log/


# Checks if file exists
if [ -f /var/log/vmware-vmsvc-root.log ]; then

	# File exists
	echo "logs are found"
	echo ""
	echo "This is the content of the original logs"

	timestamp=($(cat /var/log/vmware-vmsvc-root.log | cut -d ' ' -f 1 | head -n 1))
	cat /var/log/vmware-vmsvc-root.log
	echo ""
	echo "This is the timestamp $timestamp"
else
	# File does not exist
	echo 'The log file does not exist'
fi

exit 0
