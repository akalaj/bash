#!/bin/bash

array=(one two three)
que='three'

if [[ " ${array[@]} " =~ " ${que} " ]]; then
	echo "Found value"
	echo ${array[@]//three*/}
else
	echo "value not found"
fi
