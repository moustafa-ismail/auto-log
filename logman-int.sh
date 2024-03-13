#! /bin/bash
#

# This files read user names age and country
#

echo 'Enter your name'
read name
echo 'Enter your age'

read age

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

exit 0
