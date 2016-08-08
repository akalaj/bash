#!/bin/bash


    #Set Varibles
    #colorize
    RED='\033[0;31m'
    NC='\033[0m' # No Color
    #pass
    PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
    #ensure decryption works or else backout
        if [ "$?" -ne 0 ]; then
                clear && echo -e "Decryption not successful. Exiting..." && exit 1;
        fi

    #cont. vars
    AUTH='mysql -uakalaj -p'$PASS''
    QUERY="SELECT table_name AS 'Table', index_name AS 'Index', GROUP_CONCAT(column_name ORDER BY seq_in_index)\
        AS 'Columns' FROM information_schema.statistics WHERE table_schema = '$DB' GROUP BY 1,2;"


    #for loop
    for DB in $($AUTH -Bse "SHOW DATABASES" 2>/dev/null); do
        echo -e "\n+$DB+\n"
        #gather index stats
        RESULTS=$(mysql -Bse "SELECT table_name AS 'Table', index_name AS 'Index', GROUP_CONCAT(column_name ORDER BY seq_in_index) AS 'Columns' FROM information_schema.statistics WHERE table_schema = '$DB' GROUP BY 1,2;" 2>/dev/null | wc -l)
        #check if there are no indexes in stats
        if [[ $RESULTS > 0 ]]; then
            $AUTH information_schema -e "SELECT table_name AS 'Table', index_name AS 'Index', GROUP_CONCAT(column_name ORDER BY seq_in_index) AS 'Columns' FROM information_schema.statistics WHERE table_schema = '$DB' GROUP BY 1,2;" 2>/dev/null
        else
            printf "\n${RED}NO INDEXES FOUND FOR $DB${NC}\n"
        fi;
    done;