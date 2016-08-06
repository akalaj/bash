#!/bin/bash

#set variable to auth into mysql instance
PASS=`openssl aes-256-cbc -d -a -in ./akalaj.pass`

#ensure variable contains info or else backout
if [ "$?" -ne 0 ]; then
        clear && echo -e "Decryption not successful. Exiting..." && exit 1;
fi

#for loop to perform schema and table maint
for i in $(mysql -uakalaj -p$PASS -Bse "SELECT SCHEMA_NAME FROM SCHEMATA WHERE SCHEMA_NAME NOT IN ('information_schema','mysql','performance_schema')");
	do
		TABLES=$(mysql -uakalaj -p$PASS -Bse "SELECT")

