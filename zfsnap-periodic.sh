#!/bin/bash

# If there is a global system configuration file, suck it in.
#
if [ -r /etc/zfsnap-periodic.conf ]; then
	. /etc/zfsnap-periodic.conf
fi

zfSnap_cmd=`which zfSnap`

if [ "x$1" == "x" ]; then
  cd `dirname $0`
  period=`pwd | awk -F'cron.' '{print $2}'`
else
  period=$1
fi

case "${period:-"DISABLED"}" in
		'hourly')
			default_ttl='3d'
			;;
		'daily')
			default_ttl='1w'
			;;
    'reboot')
			default_ttl='1w'
      ;;
		'weekly')
			default_ttl='1m'
			;;
		'monthly')
			default_ttl='6m'
			;;
		*)
			echo "ERR: Unexpected error" > /dev/stderr
			exit 1
			;;
esac

# CREATE PART

var="${period}_zfsnap_enable"; zfsnap_enable=${!var:-$zfsnap_enable}
var="${period}_zfsnap_verbose"; zfsnap_verbose="${!var:-$zfsnap_verbose}"
var="${period}_zfsnap_flags"; zfsnap_flags="${!var:-$zfsnap_flags}"
var="${period}_zfsnap_enable_prefix"; zfsnap_enable_prefix="${!var:-$zfsnap_enable_prefix}"
var="${period}_zfsnap_prefix"; zfsnap_prefix="${!var:-$zfsnap_prefix}"
var="${period}_zfsnap_ttl"; zfsnap_ttl="${!var:-$zfsnap_ttl}"
var="${period}_zfsnap_fs"; zfsnap_fs="${!var:-$zfsnap_fs}"
var="${period}_zfsnap_recursive_fs"; zfsnap_recursive_fs="${!var:-$zfsnap_recursive_fs}"

case "${zfsnap_enable:-"NO"}" in
	[Yy][Ee][Ss])
    OPTIONS="${zfsnap_flags}"

		case "${zfsnap_verbose:-"NO"}" in
		[Yy][Ee][Ss])
			OPTIONS="$OPTIONS -v"
			;;
		esac

		case "${zfsnap_enable_prefix:-"YES"}" in
		[Yy][Ee][Ss])
			OPTIONS="$OPTIONS -p ${zfsnap_prefix:-"${period}-"}"
			;;
		esac

		$zfSnap_cmd $OPTIONS -a ${zfsnap_ttl:-"$default_ttl"} $zfsnap_fs -r $zfsnap_recursive_fs
		#exit $?
		;;

	*)
		#exit 0
		;;
esac


# DELETE PART
var="${period}_zfsnap_delete_enable";  zfsnap_delete_enable=${!var:-$zfsnap_delete_enable}
var="${period}_zfsnap_delete_flags";   zfsnap_delete_flags=${!var:-$zfsnap_delete_flags}
var="${period}_zfsnap_delete_verbose"; zfsnap_delete_verbose=${!var:-$zfsnap_delete_verbose}
var="${period}_zfsnap_delete_prefixes"; zfsnap_delete_prefixes=${!var:-$zfsnap_delete_prefixes}

case "${zfsnap_delete_enable-"NO"}" in
	[Yy][Ee][Ss])
		OPTIONS="$zfsnap_delete_flags"

		case "${zfsnap_delete_verbose-"NO"}" in
		[Yy][Ee][Ss])
			OPTIONS="$OPTIONS -v"
			;;
		esac

		for prefix in $zfsnap_delete_prefixes; do
			OPTIONS="$OPTIONS -p $prefix"
		done

		$zfSnap_cmd -d $OPTIONS -p 'hourly-' -p 'daily-' -p 'weekly-' -p 'monthly-' -p 'reboot-'
		exit $?
		;;

	*)
		exit 0
		;;
esac

# vim: set ts=4 sw=4:
