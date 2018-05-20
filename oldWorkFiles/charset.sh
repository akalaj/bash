#!/bin/bash

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

for TABLES in ($AUTH -Bse "SELECT TABLE_NAME FROM information_schema.TABLES")
