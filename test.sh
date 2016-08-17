    #!/bin/bash

    #Execution plan
    #Run this in a screen at 6am on the insight server and monitor progress

    #Set Varibles
    USER='root'
    PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
    #ensure decryption works or else backout
        if [ "$?" -ne 0 ]; then
                clear && echo -e "Decryption not successful. Exiting..." && exit 1;
        fi

    #cont. vars
    AUTH='mysql -u'$USER' -p'$PASS''
    CHARSET='utf8mb4'
    COLLATION='utf8mb4_unicode_520_ci'

    #for loop to perform schema and table maint
    #gather DBs that we'll work on

    for DB in $($AUTH information_schema -Bse "SELECT SCHEMA_NAME FROM SCHEMATA WHERE SCHEMA_NAME NOT IN ('mysql','performance_schema','information_schema')" 2>/dev/null); do

        for TABLE in $($AUTH information_schema -Bse "SELECT TABLE_NAME FROM TABLES WHERE TABLE_SCHEMA='$DB'" 2>/dev/null); do

            #Alter statement
            echo -e "\nSTART TIME: `date +%T`" &&
            $AUTH -e "SELECT '$DB.$TABLE' AS 'Altering...'" 2>/dev/null &&
            $AUTH $DB -e "ALTER TABLE \`$TABLE\` CONVERT TO CHARACTER SET \`$CHARSET\` COLLATE \`$COLLATION\`;" 2> review.log &&
            echo "END TIME: `date +%T`"

        done;

    done;