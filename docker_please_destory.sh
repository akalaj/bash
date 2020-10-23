#!/bin/bash

#Check if specific name was requested to be terminated
if [[ -z "$1" ]]; then
	#If no name specified, obtain hash/name from bottom of `docker ps` list
	CONTAINER_HASH=$(docker ps | tail -1 | awk {'print $1'})
	IMAGE_NAME=$(docker ps | tail -1 | awk {'print $NF'})
	
	#Safety check if `docker ps` list is empty. If not, DESTROY!
	if [[ $CONTAINER_HASH == "CONTAINER"  ]]; then
	    echo -e "No Docker Images Found"
	else
	    docker stop $CONTAINER_HASH && docker rm $CONTAINER_HASH
	    echo -e "Killed ${IMAGE_NAME}"
	fi
else
#If name was specified.
	#Check if name exists, continue based on names existence.
	if [[ $(docker ps | awk {'print $NF'} | grep $1) == "" ]]; then
		echo -e "Could not find Docker container with name '${1}'"
	else
		CONTAINER_HASH=$(docker ps | grep $1 | awk {'print $1'})
		IMAGE_NAME=$(docker ps | grep $1 | awk {'print $NF'})
		docker stop $CONTAINER_HASH && docker rm $CONTAINER_HASH
		echo -e "Killed ${IMAGE_NAME}"
	fi
fi
