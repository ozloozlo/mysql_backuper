#!/bin/bash

##########
# CONFIG #
##########

USER="root"
PASSWORD="12345678"
DBNAME="world"
SKIPPED_TABLE1="information_schema"
SKIPPED_TABLE2="performance_schema"
SKIPPED_TABLE3="mysql"
MYSQLDUMP="/usr/bin/mysqldump"
MYSQL="/usr/bin/mysql"
BACKUP_DIR="/var/mysql_backup"
LOG_DIR="/var/log"
LOG_FILE="$(date +'%Y-%m-%d')-sql_backup.log"
ADMINS_EMAIL="prososov@gmail.com"

##############
# THE SCRIPT #
##############
# create backup dir
if [ ! -d "$BACKUP_DIR" ]; then
    echo "make dir: "$BACKUP_DIR
    mkdir -p $BACKUP_DIR
fi

# create log file

if [ ! -f "$LOG_DIR/$LOG_FILE" ]; then
    echo "create file: "$LOG_FILE 
    touch $LOG_DIR/$LOG_FILE
fi

# create dumps
for TABLE in $(mysql -u $USER -p$PASSWORD $DBNAME -e 'show tables' -s --skip-column-names)
do
	if [[ $TABLE != $SKIPPED_TABLE1 ]] && [[ $TABLE != $SKIPPED_TABLE2 ]] && [[ $TABLE != $SKIPPED_TABLE3 ]]; then 
		echo "dumping table: "$TABLE >> $LOG_DIR/$LOG_FILE
		mysqldump -u $USER -p$PASSWORD --add-drop-table --add-locks -q -Q --disable-keys --extended-insert $DBNAME $TABLE -r $BACKUP_DIR/$(date +'%Y-%m-%d')-$TABLE.sql >> $LOG_DIR/$LOG_FILE 2>&1
		echo "dumping is FINISHED for table: "$TABLE >> $LOG_DIR/$LOG_FILE
	fi
done
echo "DONE!!!" >> $LOG_DIR/$LOG_FILE

# sending e-mail
echo "From: MYSQL_BACKUPER <sender@email.com>" > /tmp/mail_template
echo "To: Admin <$ADMINS_EMAIL> " >> /tmp/mail_template
echo "Subject: MySQL Backups $(date +'%Y-%m-%d')" >> /tmp/mail_template
echo "Job was done on $(date +'%Y-%m-%d'). $LOG_FILE succesfully created. " >> /tmp/mail_template
cat /tmp/mail_template |   sendmail $ADMINS_EMAIL
