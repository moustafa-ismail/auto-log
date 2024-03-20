#! /bin/bash
#



# This is the log manager part

cd /var/log/


# Checks if file exists
if [ -f /var/log/vmware-vmsvc-root.log ]; then

	# File exists
	echo ""
	echo "logs are found"
	echo ""
	echo "This is an analysis  of the original logs"
	echo ""

	# Reporting analysis of the log file
	
	
	echo "START REPORT
-----------
Number of Entries: $(cat /var/log/vmware-vmsvc-root.log | wc -l)
$(awk '/exit code: 0/ {count++} END {print "Number of error occurrences", count}' /var/log/vmware-vmsvc-root.log)
$(awk '/exit code: 1/ {count++} END {print "Number of successful occurrences", count}' /var/log/vmware-vmsvc-root.log)
$(awk '/Plugin/ {count++} END {print "Number of plugins:", count}' /var/log/vmware-vmsvc-root.log)
-----------------------------------
END REPORT" > log_analysis_report.txt

	echo ""

	# Get top timestamp of original file
	
	timestamp=($(cat /var/log/vmware-vmsvc-root.log | cut -d ' ' -f 1 | head -n 1))

	
	# Get number of existing old backup
	
	n=$(ls /var/log/ | grep -c -E .myold)
	
	if (( n==0 )); then
		
		echo "This is your first backup"
		echo ""

	fi


	# Check for the number of backups and delete the oldest one if more than four exists
	echo "Checking existing backups ...."
	echo ""

	if (( n>3 )); then

		echo "The number of backups exceeds 4, the oldest backup will be deleted"
		echo ""
		
		# Getting name of the oldest backup
		
		old_backup=$(ls /var/log | grep -E '.log[0-9]*.myold' | head -n 1)


		
		echo "This is the name of the oldest backup: $old_backup"
		echo ""

		# Deleting the oldest backup

		echo "Deleting $old_backup ..."

		rm -i "/var/log/$old_backup"
		
		echo "Oldest backup is deleted"
	fi

	# Create backup using the last timestamp and adding .myold
	
	echo "Backup is being created ... ;)"
	echo ""

	cp /var/log/vmware-vmsvc-root.log /var/log/"$timestamp.log$n.myold"


else
	# File does not exist
	echo 'The log file does not exist'
fi

exit 0
