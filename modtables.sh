    #!/bin/bash

    #Set Varibles
    PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
    #ensure decryption works or else backout
        if [ "$?" -ne 0 ]; then
                clear && echo -e "Decryption not successful. Exiting..." && exit 1;
        fi

    #cont. vars
    AUTH='mysql -uakalaj -p'$PASS''
    CHARSET='utf8'
    COLLATION='utf8_unicode_ci'

    #for loop to perform schema and table maint
    #gather DBs that we'll work on
    for DB in $($AUTH information_schema -Bse "SELECT SCHEMA_NAME FROM SCHEMATA WHERE SCHEMA_NAME NOT IN ('mysql','performance_schema','information_schema')" 2>/dev/null); do

            #2nd for loop, run against all tables for previously found DBs
            for TABLE in $($AUTH information_schema -Bse "SELECT TABLE_NAME FROM TABLES WHERE TABLE_SCHEMA='$DB'" 2>/dev/null); do

                #Notify about table alteration
                sleep 2
                TIME="START TIME: `date +%T`"
                NOTICE="$TIME: Altering $TABLE..."
                $AUTH -e "SELECT '$DB.$TABLE' AS 'Altering...'"
                sleep 2
                echo -e "\n$NOTICE\n$TIME" >> review.log

                #pt schema change
                pt-online-schema-change --alter 'CONVERT TO CHARACTER SET $CHARSET COLLATE $COLLATION'\
                --statistics --execute h=localhost,D=$DB,t=$TABLE,u=akalaj --password=$PASS >> review.log
                #Catch exception
                if [ "$?" -ne 0 ]; then
                clear && echo -e "There was an issue with the alteration"
                echo -e "\nLOG STATUS\n\n`cat review.log`"
                fi

                #confirm table alteration
                echo -e "\n\nContinue?\n"
                read GO
                if [[ $GO == 'y' ]]; then
                    :
                else
                    "Issue....exiting..." && exit 1
                fi

                #Message completion
                END="END TIME: `date +%T`"
                echo $END
                echo $END >> review.log

            done;

    done;