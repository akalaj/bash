#!/bin/bash

PASS=`openssl aes-256-cbc -d -a -in /home/akalaj/akalaj.pass`
AUTH='mysql -uakalaj -p'$PASS''


$AUTH -e "SELECT 1"
