    #!/bin/bash

    #Execution plan

    #Set Varibles
    USER='root'
    PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
    #ensure decryption works or else backout
        #if [ "$?" -ne 0 ]; then
        #        clear && echo -e "Decryption not successful. Exiting..." && exit 1;
        #fi

    #cont. vars
    AUTH='mysql -u'$USER' -p'$PASS''
    DAUTH='mysqldump -u'$USER' -p'$PASS''
    DATABASE=$1
    #TABLE=$2
    CHARSET='utf8mb4'
    COLLATION='utf8mb4_unicode_520_ci'



        for TABLES in $LIST; do
    CHKCHARSET=$($AUTH $DATABASE -Bse "SHOW CREATE TABLE $TABLES" 2>/dev/null | grep -o -P '.{0}CHARSET=[[:alnum:]]*.{0}' 2>/dev/null)
    CHKCOLL=$($AUTH information_schema -Bse"SELECT TABLE_COLLATION FROM TABLES WHERE TABLE_SCHEMA='$DATABASE' AND TABLE_NAME='$TABLES'" 2>/dev/null)
    echo "===$TABLES==="
    echo $CHKCHARSET
    echo "COLLATION=$CHKCOLL"
    echo "======="
        done;
