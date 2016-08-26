    #!/bin/bash

    #Execution plan
    #Run this in a screen at 6am on the insight server and monitor progress

    #Set Varibles
    USER='akalaj'
    #PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
    #ensure decryption works or else backout
        #if [ "$?" -ne 0 ]; then
        #        clear && echo -e "Decryption not successful. Exiting..." && exit 1;
        #fi

    #cont. vars
    AUTH='mysql -u'$USER' -p'$PASS''
    DAUTH='mysqldump -u'$USER' -p'$PASS''
    DATABASE=$1
    TABLE=$2
    CHARSET='utf8mb4'
    COLLATION='utf8mb4_unicode_520_ci'

    CHKCHARSET=$(mysql $DATABASE -Bse "SHOW CREATE TABLE $TABLE" 2>/dev/null | grep -o -P '.{0}CHARSET=[[:alnum:]]*.{0}')

    echo $CHKCHARSET