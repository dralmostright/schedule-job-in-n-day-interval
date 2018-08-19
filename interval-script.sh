#/bin/bash
#############################################################
# Author : Suman Adhikari                                  ##
# Company :					           ##
# Description :                                            ##
#                                                          ##
# Version : 1.0                                            ##
#                                                          ##
# Last Update:						   ##
#							   ##
# Update Comments:				           ##
#############################################################

##
## Set Global Variables
##
JOB_INTERVAL=15
JOB_DAY=
LOCK_DIR=/tmp/manual-job
LOCK_FILE=.manual-job.trk
LOCK_FILE_STATUS=`[ -f $LOCK_DIR/$LOCK_FILE ] && echo 0 || echo 1`

##
## For extra requirements
##
#TODAY_DAY=`date +%A`
#echo $TODAY_DAY
#echo $LOCK_FILE_STATUS

##
## Create a function to make file
##
mkfile() 
      { 
      mkdir -p -- "$1" && touch -- "$1"/"$2" 
      }

##
## check if JOB_DAY is set or not
##

#if [[ "${JOB_DAY}" = "" ]]
#	then
		#echo "The JOB_DAY var is not set."
#fi

##
## Make job status file if not exits
##
if [[ "$LOCK_FILE_STATUS" = "1" ]]
	then
	mkfile $LOCK_DIR $LOCK_FILE
        echo "-1" > $LOCK_DIR/$LOCK_FILE
fi

##
## Check if interval is set or not
##
if [[ "$JOB_INTERVAL" = "" ]]
	then
	echo "JOBERR : 001, The JOB_INTERVAL var is not set. Cannot Proceed."
else 
        tracker=`cat $LOCK_DIR/$LOCK_FILE`
        #echo $tracker
	if [[ "$tracker" -lt 0 ]]
        	then
		remcount=`expr $JOB_INTERVAL - 1`
		echo $remcount > $LOCK_DIR/$LOCK_FILE
		
		##
		## Place your script here
		## recommended to use absolute path
		##
        	/software/scripts/job-script.sh
	else
		tracker=`expr $tracker - 1`
		echo $tracker > $LOCK_DIR/$LOCK_FILE 
	fi

fi

