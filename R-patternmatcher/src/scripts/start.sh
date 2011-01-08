#!/bin/bash
cd "`dimame $0`/.."
apphome="`pwd`"
binhome="`pwd`/bin"
libhome="`pwd`/lib"
libhome_esc=`echo $libhome | sed's/\//\\\\\//g'`
allowrun=O
currenthost=`hostname`
allowedhosts='<ALLOWED_HOSTS>'
for allowed_host in $allowedhosts ; do
	if [ "$allowed host" == "$currenthost" ]; then
		allowrun=1
	fi
done

if [ $allowrun == 0 ]; then
	echo "ERROR: You can only run this application from the following host(s): $allowedhosts"
	echo "ERROR: Current host: $currenthost"
	exit -1
fi

sed "s/<LIB_HOME>/$libhome_esc/g" $binhome/.Rprofile.template > $binhome/.Rprofile

echo -------- RServe --------
echo "Host: $currenthost"
echo "User: `whoami`"
echo "Dir: `pwd`"

cd $binhome
# For interactive/debug, use: R CMD Rserve.dbg
R CMD Rserve
