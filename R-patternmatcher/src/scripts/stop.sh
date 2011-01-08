#!/bin/bash
rservepid=`pgrep Rserve`

if [ "$rservepid" != "" ] ; then
	echo "Found pid to kill: $rservepid"
	kill -9 $rservepid
	echo "Killed."
else
	echo "No pid found."
fi

