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


	# Get top timestamp of original file
	
	timestamp=($(cat /var/log/vmware-vmsvc-root.log | cut -d ' ' -f 1 | head -n 1))

	
	# Get number of existing old backup
	
	n=$(ls /var/log/ | grep -c -E .myold)
	
	if (( n==0 )); then
		
		echo "This is your first backup"
		echo ""

	fi


	# Create backup using the last timestamp and adding .old
	
	echo "As if the backup has been created, it is not really created ;)"
	echo ""

	#cp /var/log/vmware-vmsvc-root.log /var/log/"$timestamp.log$n.myold"
	
	#if (( n>3 )); then

	#	echo "The number of backups exceeds 4, the oldest backup will be deleted"
	#	echo ""



	echo "***A backup has been created***"

	echo ""
	echo "Here is a copy of the origingal log"
	echo ""

	cat /var/log/vmware-vmsvc-root.log
	echo ""
	echo "This is the timestamp $timestamp"
else
	# File does not exist
	echo 'The log file does not exist'
fi

exit 0
