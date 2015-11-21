#!/sbin/runscript
# Copyright (c) 2005 Mark Harvey
# All rights reserved.
#
# Author: Mark Harvey, 2005 - 2009
#	  mark794@gmail.com
#	  mark_harvey@symantec.com
#
#         Adrien Dessemond, 2012
#	  adessemond@funtoo.org
#
# /etc/init.d/mhvtl
#
# Script to start mhvtl kernel module & vtltape userspace daemon
#
# Virtual tape & library system
# 
# Modification History:
#    2012-10-24 adessemond - OpenRC integration - Rework of original (designed RedHat-like systems)
#    2010-04-26 hstadler - parsing 10th argument - function add_drive
# 


initvars() {
	USER=vtl
	MHVTL_CONFIG_PATH=/etc/mhvtl
	MHVTL_HOME_PATH=/var/spool/media/vtl
	DEVICE_CONF=$MHVTL_CONFIG_PATH/device.conf
}

# add_library(DevID, Channel, Target, Lun, Vend, Prod, ProdRev, S/No)

add_library()
{
	ID=$1
	CH=$2
	TARGET=$3
	LUN=$4

	printf "Library: %02d CHANNEL: %02d TARGET: %02d LUN: %02d\n" \
		$ID $CH $TARGET $LUN >> $DEVICE_CONF
	echo " Vendor identification: $5" >> $DEVICE_CONF
	echo " Product identification: $6" >> $DEVICE_CONF
	echo " Unit serial number: $8" >> $DEVICE_CONF
	printf " NAA: %02d:22:33:44:ab:%02d:%02d:%02d\n" \
		$ID $CH $TARGET $LUN >> $DEVICE_CONF
	echo " Home directory: $MHVTL_HOME_PATH" >> $DEVICE_CONF
	echo " Backoff: 400" >> $DEVICE_CONF
	echo "# fifo: /var/tmp/mhvtl" >> $DEVICE_CONF
	echo "" >> $DEVICE_CONF
}

# add_drive(DevID, Channel, Target, Lun, Vend, Prod, ProdRev, S/No, LibID, Slot)
add_drive()
{
	ID=$1
	CH=$2
	TARGET=$3
	LUN=$4
	VENDORID=$5
	PRODUCTID=$6
	PRODUCTREV=$7
	UNITSERNO=$8
	LIB=$9

	# get arg 10 & 11
	shift 9
	SLOT=$1
	DENSITY=$2

	printf "Drive: %02d CHANNEL: %02d TARGET: %02d LUN: %02d\n" \
		$ID $CH $TARGET $LUN >> $DEVICE_CONF
	printf " Library ID: %02d Slot: %02d\n" \
		$LIB $SLOT >> $DEVICE_CONF
	echo " Vendor identification: $VENDORID" >> $DEVICE_CONF
	echo " Product identification: $PRODUCTID" >> $DEVICE_CONF
	echo " Unit serial number: $UNITSERNO" >> $DEVICE_CONF
	printf " NAA: %02d:22:33:44:ab:%02d:%02d:%02d\n" \
		$LIB $CH $TARGET $LUN >> $DEVICE_CONF
	echo " Compression: factor 1 enabled 1" >> $DEVICE_CONF
	echo " Compression type: lzo" >> $DEVICE_CONF
	echo " Backoff: 400" >> $DEVICE_CONF
	echo "# fifo: /var/tmp/mhvtl" >> $DEVICE_CONF
}

add_ibm_ultrium_drive()
{
	# ID=$1 CH=$2 TARGET=$3 LUN=$4 UNITSERNO=$5 LIB=$6 SLOT=$7
	add_drive $1 $2 $3 $4 "IBM" "ULT3580-TD1" "550V" $5 $6 $7 42
	echo "" >> $DEVICE_CONF
}

add_ibm_ultrium_2_drive()
{
	# ID=$1 CH=$2 TARGET=$3 LUN=$4 UNITSERNO=$5 LIB=$6 SLOT=$7
	add_drive $1 $2 $3 $4 "IBM" "ULT3580-TD2" "550V" $5 $6 $7 44
	echo "" >> $DEVICE_CONF
}

add_ibm_ultrium_3_drive()
{
	# ID=$1 CH=$2 TARGET=$3 LUN=$4 UNITSERNO=$5 LIB=$6 SLOT=$7
	add_drive $1 $2 $3 $4 "IBM" "ULT3580-TD3" "550V" $5 $6 $7 46
	echo "" >> $DEVICE_CONF
}

add_ibm_ultrium_4_drive()
{
	# ID=$1 CH=$2 TARGET=$3 LUN=$4 UNITSERNO=$5 LIB=$6 SLOT=$7
	add_drive $1 $2 $3 $4 "IBM" "ULT3580-TD4" "550V" $5 $6 $7 48
	echo "" >> $DEVICE_CONF
}

add_ibm_ultrium_5_drive()
{
	# ID=$1 CH=$2 TARGET=$3 LUN=$4 UNITSERNO=$5 LIB=$6 SLOT=$7
	add_drive $1 $2 $3 $4 "IBM" "ULT3580-TD5" "550V" $5 $6 $7 50
	echo "" >> $DEVICE_CONF
}

add_stk_t10kb_drive()
{
	# ID=$1 CH=$2 TARGET=$3 LUN=$4 UNITSERNO=$5 LIB=$6 SLOT=$7
	add_drive $1 $2 $3 $4 "STK" "T10000B" "550V" $5 $6 $7 50
	echo "" >> $DEVICE_CONF
}


update_device_conf() {

	# Create a 'device.conf' if it does not exist...
	if [ ! -f $DEVICE_CONF ]; then

		ewarn "$DEVICE_CONF not present, creating a default one"
		mkdir -p $MHVTL_CONFIG_PATH
		cat > $DEVICE_CONF << VTL_CONF

# Version of the configuration file format
# Do not change the value for 'VERSION' by yourself.
VERSION: 5

# VPD page format:
# <page #> <Length> <x> <x+1>... <x+n>
# NAA format is an 8 hex byte value seperated by ':'
# Note: NAA is part of inquiry VPD 0x83
#
# Each 'record' is separated by one (or more) blank lines.
# Each 'record' starts at column 1
# Serial num max len is 10.
# Compression: factor X enabled 0|1
#     Where X is zlib compression factor	1 = Fastest compression
#						9 = Best compression
#     enabled 0 == off, 1 == on
#
# fifo: /var/tmp/mhvtl
# If enabled, data must be read from fifo, otherwise daemon will block
# trying to write.
# e.g. cat /var/tmp/mhvtl (in another terminal)

VTL_CONF

		# index channel target LUN Vendor ProdID ProdRev S/No
		add_library 10 0 0 0 "STK" "L700"  "550V"  "XYZZY_A"

		# index channel target LUN Vendor ProdID ProdRev S/No Lib# Slot
		add_ibm_ultrium_5_drive 11 0 1 0 "XYZZY_A1" 10 1
		add_ibm_ultrium_5_drive 12 0 2 0 "XYZZY_A2" 10 2
		add_ibm_ultrium_4_drive 13 0 3 0 "XYZZY_A3" 10 3
		add_ibm_ultrium_4_drive 14 0 4 0 "XYZZY_A4" 10 4

		add_library 30 0 8 0 "STK" "L80"  "550V"  "XYZZY_B"
		add_stk_t10kb_drive 31 0 9 0 "XYZZY_B1" 30 1
		add_stk_t10kb_drive 32 0 10 0 "XYZZY_B2" 30 2
		add_stk_t10kb_drive 33 0 11 0 "XYZZY_B3" 30 3
		add_stk_t10kb_drive 34 0 12 0 "XYZZY_B4" 30 4

	else

		# Give up is device.conf is at wrong version..
		V=`awk '/VERSION:/ {print $2}' $DEVICE_CONF`
		if [ $V -lt 4 ]; then
			eerror " $DEVICE_CONF is not at the correct version"
			eend 1;
		fi

	fi # End if [ ! -f $DEVICE_CONF ]

}


update_mhvtl_conf() {

	# Create a 'mhvtl.conf' if it does not exist...
	if [ ! -f $MHVTL_CONFIG_PATH/mhvtl.conf ]; then

		ewarn "$MHVTL_CONFIG_PATH/mhvtl.conf not present, creating a default one"
		mkdir -p $MHVTL_CONFIG_PATH
		cat > $MHVTL_CONFIG_PATH/mhvtl.conf << VTL_CONF

# Home directory for config file(s)
MHVTL_CONFIG_PATH=$MHVTL_CONFIG_PATH

# Default media capacity (500 M)
CAPACITY=500

# Set default verbosity [0|1|2|3]
VERBOSE=1

# Set kernel module debuging [0|1]
VTL_DEBUG=0

VTL_CONF

	else

		# Upgrade mhvtl.conf with 'MHVTL_CONFIG_PATH' default
		EXIST=`grep MHVTL_CONFIG_PATH $MHVTL_CONFIG_PATH/mhvtl.conf | wc -l`

		if [ $EXIST -eq 0 ]; then
			ewarn "MHVTL_CONFIG_PATH/mhvtl.conf upgraded (missing MHVTL_CONFIG_PATH option)"
			echo "" >> $MHVTL_CONFIG_PATH/mhvtl.conf
			echo "# Default config directory" >> $MHVTL_CONFIG_PATH/mhvtl.conf
			echo "MHVTL_CONFIG_PATH=$MHVTL_CONFIG_PATH" >> $MHVTL_CONFIG_PATH/mhvtl.conf
		fi

		# Earlier versions of mhvtl.conf may not contain the 'CAPACITY' string.
		# Update if nessessary..

		EXIST=`grep CAPACITY $MHVTL_CONFIG_PATH/mhvtl.conf|wc -l`
		if [ $EXIST -eq 0 ]; then
			ewarn "MHVTL_CONFIG_PATH/mhvtl.conf upgraded (missing CAPACITY option)"
			echo "" >> $MHVTL_CONFIG_PATH/mhvtl.conf
			echo "# Default media capacity" >> $MHVTL_CONFIG_PATH/mhvtl.conf
			echo CAPACITY=500 >> $MHVTL_CONFIG_PATH/mhvtl.conf
		fi

	fi

	# Loads mhvtl variables
	. $MHVTL_CONFIG_PATH/mhvtl.conf

}

update_library_contents() {

	# Now check for for 'library_contents'
	LIBLIST=`awk '$1 == "Library:" {print $2}' $DEVICE_CONF`
	for LIBID in $LIBLIST
	do
		if [ ! -f $MHVTL_CONFIG_PATH/library_contents.$LIBID ]; then
		
			ewarn "$MHVTL_CONFIG_PATH/library_contents.$LIBID not found, creating a default one"
			ewarn "Please stop mhvtl & edit $MHVTL_CONFIG_PATH/library_contents.$LIBID to suit your requirements"

			cat > $MHVTL_CONFIG_PATH/library_contents.$LIBID << CONF_SAMPLE

# Version of the configuration file format
# Do not change the value for 'VERSION' by yourself.
VERSION: 2

CONF_SAMPLE

			# Count number of drives in this library
			DRV_COUNT=`grep "Library ID: $LIBID" $DEVICE_CONF|wc -l`
			# Add a 'Drive X:' for each drive
			for a in `seq 1 $DRV_COUNT`
			do
				printf "Drive %d:\n" $a >> $MHVTL_CONFIG_PATH/library_contents.$LIBID
			done
			cat >> $MHVTL_CONFIG_PATH/library_contents.$LIBID << CONF_SAMPLE

Picker 1:

MAP 1:
MAP 2:
MAP 3:
MAP 4:

# Slot 1 - ?, no gaps
# Slot N: [barcode]
# [barcode]
# a barcode is comprised of three fields: [Leading] [identifier] [Trailing]
# Leading "CLN" -- cleaning tape
# Leading "W" -- WORM tape
# Leading "NOBAR" -- will appear to have no barcode
# If the barcode is at least 8 character long, then the last two characters are Trailing
# Trailing "S3" - SDLT600
# Trailing "X4" - AIT-4
# Trailing "L1" - LTO 1, "L2" - LTO 2, "L3" - LTO 3, "L4" - LTO 4, "L5" - LTO 5
# Training "LT" - LTO 3 WORM, "LU" LTO 4 WORM, "LV" LTO 5 WORM
# Trailing "TA" - T10000+
# Trailing "JA" - 3592+
# Trailing "JB" - 3592E05+
# Trailing "JW" - WORM 3592+
# Trailing "JX" - WORM 3592E05+
#
CONF_SAMPLE

			if [ $LIBID == 10 ]; then

				# LTO-4 Media
				for a in `seq 1 20`; do
					printf "Slot $a: E0%02d%02dL4\n" $LIBID $a \
					>> $MHVTL_CONFIG_PATH/library_contents.$LIBID
				done

				printf "Slot 21: \n" >> $MHVTL_CONFIG_PATH/library_contents.$LIBID
				printf "Slot 22: CLN%02d1L4\n" $LIBID >> $MHVTL_CONFIG_PATH/library_contents.$LIBID
				printf "Slot 23: CLN%02d2L5\n" $LIBID >> $MHVTL_CONFIG_PATH/library_contents.$LIBID

				for a in `seq 24 29`; do
					printf "Slot $a:\n" \
					>> $MHVTL_CONFIG_PATH/library_contents.$LIBID
				done

				# LTO-5 Media
				for a in `seq 30 39`; do
					printf "Slot $a: F0%02d%02dL5\n" $LIBID $a \
					>> $MHVTL_CONFIG_PATH/library_contents.$LIBID
				done
			fi # End if [ $LIBID == 10 ]

			# STK T10K media
			if [ $LIBID == 30 ]; then
				for a in `seq 1 39`; do
				printf "Slot $a: G0%02d%02dTA\n" $LIBID $a \
					>> $MHVTL_CONFIG_PATH/library_contents.$LIBID
				done
				printf "Slot 40: CLN%02d3TA\n" $LIBID \
					>> $MHVTL_CONFIG_PATH/library_contents.$LIBID
			fi # End if [$LIBID == 30 ]
		fi

	done # End for for LIBID in $LIBLIST

}


update_configuration_files () {

	update_device_conf
	update_mhvtl_conf
	update_library_contents
}

error_exit() {

	if [ ! $1 -eq 0 ]; then
		eerror $2
		exit $1
	fi

	eend $1
}

depend() {
        after logger
}


start() {

	initvars

	ebegin "Starting mhvtl"

	# Create bare minimal template and loads the value ($VTL_DEBUG in particular)
	update_configuration_files

	if [ ! -e /sys/module/mhvtl  ]; then
		modprobe mhvtl opts=$VTL_DEBUG
	fi

	if [ ! -e /sys/module/mhvtl/version  ]; then
		error_exit 1 "mhvtl kernel modules have not been loaded please check your /etc/conf.d/modules" 
	fi

	vtlMSBVersion=`cat /sys/module/mhvtl/version|awk -F. '{print $1}'`
	vtlMidVersion=`cat /sys/module/mhvtl/version|awk -F. '{print $2}'`
	vtlLSBVersion=`cat /sys/module/mhvtl/version|awk -F. '{print $3}'`

	if [ $vtlMidVersion -lt 18 ] && [ $vtlLSBVersion -lt 11 ]; then

		error_exit 1 "mhvtl kernel modules are too old, please emerge a more recent version of sys-block/mhvtl-modules"
	fi

	# Load sg driver if not already loaded..
	if [ ! -e /sys/module/sg ]; then
		/sbin/modprobe sg
		sleep 1
	fi

	# Should be proof against 'vi vtltape' match
	if [ ! -z "`ps -eo cmd|awk '/vtllibrary|vtltape/ {print $1}'|egrep 'vtltape|vtllibrary'`" ];
	then
		error_exit 1 "mhvtl already running..."
	fi

	chown -R $USER:$USER $MHVTL_CONFIG_PATH

	# Build Library media

	make_vtl_media $USER
	if [ $? != 0 ]; then
		error_exit 1 "make_vtl_media failed.. Could not start daemons"
	fi

	# Build Library config - No. of drives & serial Nos etc..
	# This also loads each tape daemon.
	build_library_config $USER
	if [ $? != 0 ]; then
		error_exit 1 "build_library_config failed.. Could not start daemons"
	fi

	error_exit 0
}


stop() {

	initvars

	ebegin "Stopping mhvtl"

	if [ -z "`ps --user $USER|grep -v TIME`" ]; then
		ewarn "mhvtl not running..."
		eend 0
	fi

	for a in `ps -eo cmd |awk '/^vtltape -q/ {print $3}'`
	do
		einfo "   Sending exit to $a"
		vtlcmd $a exit
		usleep 100 > /dev/null 2>&1 /dev/null
	done

	for a in `ps -eo cmd |awk '/^vtllibrary -q/ {print $3}'`
	do
		einfo "   Sending exit to $a"
		vtlcmd $a exit
		usleep 100 > /dev/null 2>&1 /dev/null
	done

	# Remove kernel module (mhvtl) along with messageQ key.
        einfo "Removing mhvtl kernel module"
	for a in `ps -eo cmd |awk '/^vtltape -q/ {print $3}'`
	do
		einfo "   Sending exit to $a"
		vtlcmd $a exit
		usleep 100 > /dev/null 2>&1 /dev/null
	done

	for a in `ps -eo cmd |awk '/^vtllibrary -q/ {print $3}'`
	do
		einfo "   Sending exit to $a"
		vtlcmd $a exit
		usleep 100 > /dev/null 2>&1 /dev/null
	done

	# Sleep long enough for the daemons to see the exit commands.
	sleep 1
	modprobe -r mhvtl

	Q_EXISTS=`ipcs -q | awk '/4d61726b/ {print $2}'`
	if [ "X$Q_EXISTS" != "X" ]; then
		ipcrm -q $Q_EXISTS
	fi

	eend 0
}
