#! /bin/bash
#

# set -x 



# Define user message function

message_user() {

	echo "Usage: $0 -a <min_backup> -b <arg2> [-c] [-d] [-f <file>]"
	echo "Options:"
	echo "\t -m <min_backup>\t minimum number of backups to keep"
	#echo "\t -b <arg2>\t required argument 2"
	echo "\t -c \t If the flag is used log analysis is stored in .txt file in same directory"
	echo "\t -d <dir>\t The directory to find logs in, default is /var/log"
	echo "\t -f <file?\t The log file to make backups from, default is /var/log/vwmare-vmsvc-root.log"
	exit 1
}

## Initializing variables

#min_backup=3
#arg2=
#flagc="h"
#filarg="/var/log/vmware-vmsvc-root.log"
#dirarg="/var/log"

# source the config file

#. /home/kali/automate-log1/auto-log/log_config.cfg

. $(pwd)/log_config.cfg

# Parse Options

while getopts ":a:b:cd:f:" opt; do
	case $opt in 
		a) min_backup="$OPTARG" ;;
		b) arg2="$OPTARG" ;;
		c) flagc="$OPTARG";;
		d) dirarg="$OPTARG" ;;
		f) filarg="$OPTARG";;
		\?) usage ;;
	esac
done





# Test for the directory argument if the directory or location exists

if [ -d "$dirarg" ]; then
	
	echo "Valid directory"

else
	echo "this is not a valid directory"
	exit 1
	

fi



echo "minbackupis $min_backup"


#if [ -z "$1" ] || [ -n "$4g" ]; then
#	
#	echo "missing required argument min_backup or dirarg"
#	message_user
#	exit 1
#	exit
#fi


# This is the log manager part

cd "$dirarg"


# Checks if file exists
if [ -f "$filarg" ]; then

	# File exists
	echo ""
	echo "logs are found"
	echo ""
	echo "This is an analysis  of the original logs"
	echo ""




	if [ -z "$flagc" ]; then
		
		# Reporting analysis of the log file
	
	
		echo "START REPORT
-----------
Number of Entries: $(cat "$filarg" | wc -l)
$(awk '/exit code: 0/ {count++} END {print "Number of error occurrences", count}' "$filarg")
$(awk '/exit code: 1/ {count++} END {print "Number of successful occurrences", count}' "$filarg")
$(awk '/Plugin/ {count++} END {print "Number of plugins:", count}' "$filarg")
-----------------------------------
END REPORT">log_analysis_report.txt

		echo ""

		echo "The log analysis has been created and can be viewed at log_analysis_report.txt"

		echo ""
	
	else
		
		echo "START REPORT
-----------
Number of Entries: $(cat "$filarg" | wc -l)
$(awk '/exit code: 0/ {count++} END {print "Number of error occurrences", count}' "$filarg")
$(awk '/exit code: 1/ {count++} END {print "Number of successful occurrences", count}' "$filarg")
$(awk '/Plugin/ {count++} END {print "Number of plugins:", count}' "$filarg")
-----------------------------------
END REPORT"



		echo ""

	fi

	# Get top timestamp of original file
	
	timestamp=($(cat "$filarg" | cut -d ' ' -f 1 | head -n 1))


else
	# File does not exist
	echo 'The log file does not exist'
	exit 1
	exit
fi


echo ""
echo "*************************************"
echo "The cpu usage before creating backups"
echo "====================================="
echo ""
echo "the process id is pid:$$"

ps -p "$$" -o pid,cmd,%cpu
echo "*************************************"
echo ""


# Check validity of min_backup (number of backups)
if (( $min_backup>2 )) && (( $min_backup<8 )); then

	echo "$min_backup is a valid number of minimum backups. Proceeding .."	
	echo ""

else
	echo "$min_backup is not a valid number of minimum backups. Valid numbers between 1 and 7, try again"
		
	exit 1
	exit
	echo ""

fi 
	
# Check number of old existing old backups and print the name of the oldest one

n=$(ls "$dirarg" | grep -c -E .myold)

if (( n==0 )); then
	
	echo "This is your first backup"
	echo ""

else
	old_backup=$(ls "$dirarg" | grep -e '.log[0-9]*.myold' | head -n 1)
	echo "$old_backup is the oldest backup"
	echo ""

fi


# Creating a copy and renaming it to the timestamp of the top log



# while the number of required backups (min_backup) is greater than number of old backups, keep creating backups
# till number of required backups is reached.
#
# else if the number of required backups is less than number of old existing backups, print a message for
# the user
# If the number of required backups equals the number of old backups (n), do nothing and print to user





if (( $n==$min_backup )); then

	echo "Number of required backups is fulfilled. exiting program ..."
	echo ""
	exit
	
elif (( $n>$min_backup )); then

		
	while true; do



		read -p "Number of existing backups exceeds required. Do you want to 
	delete oldest backups down to required number?(Y/N)" yn
		echo ""
		case $yn in
			[Yy]* ) 
				while (($n!=$min_backup)); do

					
					old_backup=$(ls "$dirarg" | grep -e '.log[0-9]*.myold' | head -n 1)
					rm -i "$dirarg"/"$old_backup"


					n=$(ls "$dirarg" | grep -c -E .myold)
					sleep 2
				
				done
				
				break;;

			[Nn]* ) exit;;
			* ) echo "Invalid response ";;
		esac
	done

else
	
	while (( $n<$min_backup )); do



		echo ""
		echo "********************************"
		echo ""
		echo "the process id is pid:$$"

		ps -p "$$" -o pid,cmd,%cpu

		echo ""
		echo "IO operations"
		echo "****"
		vmstat | tail -n 1 | cut -d ' ' -f 26,30
		echo "****"

		echo "********************************"

		echo ""
		echo ""


		ind=$(ls "$dirarg" | sed -n 's/.*log\([0-9]\+\).myold/\1/p' | tail -n 1)
		
		# Create backup using the last timestamp and adding .myold
		
		echo "Backup no. $((n+1)) is being created ... ;)"

		echo ""

		cp "$filarg" "$dirarg"/"$timestamp.log$((ind+1)).myold"
		
		sleep 2

		((n++))
		


	done


	echo ""
	echo ""
	echo ""
	echo "Backup creation is done. ;)"

fi



# Monitor CPU usage consumption

echo ""
echo "********************************"
echo "CPU usage after creating backups"
echo "================================"
echo ""
echo "the process id is pid:$$"

ps -p "$$" -o pid,cmd,%cpu

echo ""
#while true; do

#	cpu_usage=$(mpstat | awk '/CPU / {print $3}')

#	top_processes=$(ps -eo pid,cmd,%cpu --sort=-%cpu | head -n 6)

#	echo "$(date +"%H:%M:%S") - CPU Usage: $(cpu_usage)%"
#	echo "Top 5 processes:"
#	echo "$top_processes"
#
#	sleep 1

#done





exit 0
