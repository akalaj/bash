#!/bin/bash

vim /etc/resolv.conf

echo -e "restarting networking"

sleep 4

service network restart

echo -e "ready? for hostname check?"
read -s

hostname -f

echo -e "ready for ping??"
read -s

ping 8.8.8.8


echo -e "ready for id change??"
read -s

echo $(hostname -f) > /etc/salt/minion_id

echo -e "ready for highstate??"
read -s

/opt/saltstack/bin/salt-call state.highstate -l debug

echo -e "ready for CVFS restart??"
read -s

service cvfs restart
