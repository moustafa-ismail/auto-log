#! /bin/bash
#

# This part reads user names age and country
#

echo 'Enter your name'
read name
echo 'Enter your age'

read age

# Check for valid age
if [[ $age =~ [0-9] ]] && (( $age>0 )) && (( $age<160 )); then 
	echo 'Thank u'

else
	echo 'sorry enter a valid age'
	age=''

fi


echo 'Enter your country'
read country

echo ''
echo ''

echo "Hello $name"
echo "Your age is $age"
echo "You are from $country"



# This is the log manager part

cd /var/log/

echo ""
echo "This is the content of the original logs"
echo ""

# Checks if file exists
if [ -f /var/log/vmware-vmsvc-root.log ]; then

	# File exists

	cat /var/log/vmware-vmsvc-root.log
	cp /var/log/vmware-vmsvc-root.log /var/log/vmware-root.log.old

	truncate -s 0 vmware-vmsvc-root.log
else
	# File does not exist
	echo 'The log file does not exist'


fi

exit 0
