#!/bin/sh

# iptables-failsafe:
# Improved Netfilter ruleset loader that backs out the whole ruleset

# Copyright 2013 Josh Cepek <josh.cepek@usa.net>
# Licensed under the GPLv3

# Edit the temp backup location and default timeout to suit your taste:
backup="/tmp/backup.iptables"
timeout=60

# Define the executable paths: (relative OK if allowed by $PATH)
bin_restore="iptables-restore"
bin_save="iptables-save"
bin_restore6="ip6tables-restore"
bin_save6="ip6tables-save"

usage() {
	echo "Usage:"
	echo
	echo "$0 [-6] [-t <sec>] <ruleset>"
	echo
	echo " arguments:"
	echo
	echo "  -h        -- show this help output and exit"
	echo "  -6        -- load IPv6 rules instead of IPv4"
	echo "  -t <sec>  -- time before failsafe fallback (default=60)"
	echo "  <ruleset> -- path to the new Netfilter ruleset to load"

	exit
}

die() {
	[ -n "$1" ] && echo "$1" >&2
	cleanup
	exit ${2:-1}
}

cleanup() { rm "$backup" 2>/dev/null; }

failsafe() {
	echo "Failsafe hit: restoring original rules" >&2
	echo "  supplied reason: $1" >&2
	"$cmd_restore" -c < "$backup" || die "WARNING!! failsafe restore failed!"
	cleanup
	exit ${2:-2}
}

# subshell timer func, passed args from the main code below
timer () {
	backup="$1"
	timeout="$2"
	cmd_restore="$3"
	ppid="$4"
	trap nice_exit HUP
	trap timer_abort TERM
	i=0
	while [ $i -lt "$timeout" ]
	do
		sleep 1
		i=$((i+1))
	done
	kill -s HUP "$ppid" 2>/dev/null
	failsafe "timeout reached"
}
timer_abort() { failsafe "requested to revert" 0; }
nice_exit() { exit 0; }
bad_exit() { exit 3; }

# Handle subshell invocation (won't return)
[ "$1" = "--subshell-timer" ] && timer "$2" "$3" "$4" "$5"

# process args
cmd_restore="$bin_restore"
cmd_save="$bin_save"
while [ -n "$1" ]
do
	case "$1" in
		-t)
			[ -z "$2" ] && die "no value passed to -t"
			timeout="$2"
			shift 2
			;;
		-6)
			cmd_restore="$bin_restore6"
			cmd_save="$bin_save6"
			shift 1
			;;
		help|-h|--help|-help)
			usage
			;;
		*)	break
			;;
	esac
done

# rules must exist
rules="$1"
[ -n "$rules" ] || die "no ruleset specified to load from"
[ -f "$rules" ] && [ -r "$rules" ] || die "cannot read rules from: $rules"
[ -z "$2" ] || die "arguments not allowed after the rulefile"

# backup current rules and apply new ones:
"$cmd_save" -c > "$backup" || die "unable to save backup ruleset"
"$cmd_restore" < "$rules" || failsafe "supplied ruleset failed"

# start timer subshell
trap bad_exit HUP
"$0" --subshell-timer "$backup" "$timeout" "$cmd_restore" "$$" &
pid=$!

echo "Ruleset applied. Auto-revert in $timeout seconds from this message."
echo "Enter 'y' to keep, anything else to revert."
echo
printf " Choice: "
read r
kill -s 0 $pid 2>/dev/null || die "" 9
if [ "$r" = "y" ]; then
	kill -s HUP $pid 2>/dev/null
else
	kill -s TERM $pid 2>/dev/null
	wait $pid
fi
