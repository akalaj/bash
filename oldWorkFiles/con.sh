#!/bin/bash

PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
#ensure decryption works or else backout


AUTH='mysql -uakalaj -p'$PASS''

NOTICE=$($AUTH -e "SELECT '$DB.$TABLE' AS 'Altering...'")

echo $NOTICE
