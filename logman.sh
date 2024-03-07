#! /bin/bash/
#
#

cd /var/log/

echo "This is the content of the original logs"
echo ""

if [ -f /var/log/vmware-vmsvc-root.log ]; then

	# File exists

	cat /var/log/vmware-vmsvc-root.log
	cp /var/log/vmware-vmsvc-root.log /var/log/vmware-root.log.old

	truncate -s 0 vmware-vmsvc-root.log
else
	# File does not exist
	echo 'The log file does not exist'


fi
