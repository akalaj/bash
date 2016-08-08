#!/bin/bash

    #Set Varibles
    PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
    #ensure decryption works or else backout
        if [ "$?" -ne 0 ]; then
                clear && echo -e "Decryption not successful. Exiting..." && exit 1;
        fi

    #cont. vars
    AUTH='mysql -uakalaj -p'$PASS''

    RESULTS=$(mysql -Bse "SELECT table_name AS 'Table', index_name AS 'Index', GROUP_CONCAT(column_name ORDER BY seq_in_index) AS 'Columns' FROM information_schema.statistics WHERE table_schema = 'archiveTables' GROUP BY 1,2;" 2>/dev/null | wc -l)
    if [[ $RESULTS > 0 ]]; then
	echo "Indexes!"
    else
	echo "Contains no indexes!!!!!OMG"
    fi
    
