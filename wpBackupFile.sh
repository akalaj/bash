#/bin/bash

###############
###Variables###
###############

DATE=$(date "+%m_%d_%y")
BACKUPFILE="/home/akalaj/archive_${DATE}.gz"
DATADIR="/var/www/html"
DISKSPACE=$(df -h | grep /dev/vda1 | awk '{print $4}' | sed "s|[A-Z]||g")
MYSQLSTATUS=$(service mysql status | grep -o running)
MYSQLDB="trojaPrime"
MYSQLUSER="root"
MYSQLBAK="trojaPrime.sql"

#################
###HEALTHCHECK###
#################

#Check if there is less than 2GB present
if [[ ! "${DISKSPACE}" -gt "2" ]]; then
	/usr/bin/clear
	echo -e "There is less than 2GB of space left.\nFree more disk to proceed with backup"
	exit 1
fi
#Check for presence of datadir
if [[ ! -d $DATADIR ]]; then
	echo -e "${DATADIR} does not exist"
	exit 1
fi
#Check mysql is running
if [[ ${MYSQLSTATUS} != "running" ]]; then
	echo -e "MySQL is not running\nPlease check MySQL status."
	exit 1
fi

##########
###MAIN###
##########

#ensure that a backup hasn't already been taken today, if so delete.

if [[ -f ${BACKUPFILE} ]]; then
	echo -e "Archive for ${BACKUPFILE} exists.\nShall we delete {y,n}?"
	ls -lah ${BACKUPFILE}
	read DELSTATEMENT
	#if statement to verify deletion
	if [[ ${DELSTATEMENT} = "y"  ]]; then
		rm -f ${BACKUPFILE}
			#if statement to ensure deletion was successful
			if [[ ! -f ${BACKUPFILE} ]]; then
				echo -e "Backup file successfully removed!\n"
			else
				echo -e "Backup file still exists for some reason.\nRemove and re-run script"
				exit 1
			fi
	else
		echo -e "'y' was not entered. Quiting..."
		exit 1
	fi
fi

#take MySQL backup
echo -e "Please provide MySQL root password\n"
read -s PASS

#test MySQL credentials
TESTVAL=$(mysql -u${MYSQLUSER} -p${PASS} -Bse 'SELECT 2+2' 2>/dev/null)
if [[ ${TESTVAL} = "4" ]]; then
	echo -e "MySQL PASSWORD is VALID"
else
	echo -e "MySQL PASSWORD NOT VALID"
	exit 1
fi

#perform backup
echo -e "Password received....attempting backup..."
mysqldump -u${MYSQLUSER} -p${PASS} --single-transaction --opt -v ${MYSQLDB} > /var/www/html/${MYSQLBAK}
echo "dump complete...\nPerforming file system backup..."

#FS backup
time GZIP=-9 tar zcvf ${BACKUPFILE} ${DATADIR}
echo -e "Backup has completed...Please review."
