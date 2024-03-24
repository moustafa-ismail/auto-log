Usage: ./custom_log_analysis -a <min_backup> -b <arg2> [-c] [-d] [-f <file>]

use sudo for elevated user

No required argument

-a	<min_backup> specifies the minimum number of backup copies from the log file

-c	flag to output log analysis in a text file instead of standard output

-d	<dir> directory where the log file to be backed up resides

-f	<file> log file needed for backup


The script will check for directory and file existence and will check for the existence
of any present old backups with the .myold extension and gives the user the option to
specify the number of copies he needs (minimum 3 and maximum 7). 3 is the default.

Backups will be created and old excess copies will be deleted and will prompt the user
to confirm deletion

The script will maintain the number of backups same as specified in the <a> argument.
