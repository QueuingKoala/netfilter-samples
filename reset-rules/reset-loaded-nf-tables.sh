#!/bin/sh

# Unloading netfilter rules the less-abusive way.
# Please see README.md for a discussion on why this is useful.

# Define your program paths.
# You may use relative paths if allowed by your env.
SAVE_BIN="/sbin/iptables-save"
RESTORE_BIN="/sbin/iptables-restore"

check_table() {
	case "$line" in
		"*filter"|"*security"|"*mangle")
			echo "
$line
:INPUT ACCEPT
:OUTPUT ACCEPT
:FORWARD ACCEPT"
			[ "$line" = "*mangle" ] && echo "
:PREROUTING ACCEPT
:POSTROUTING ACCEPT"
			;;
		"*nat"|"*raw")
			echo "
$line
:PREROUTING ACCEPT
:OUTPUT ACCEPT"
			[ "$line" = "*nat" ] && echo "
:POSTROUTING"
			;;
		*)
			return
			;;
	esac
	echo "COMMIT"
}
("$SAVE_BIN" | while read line
	do check_table; done) | "$RESTORE_BIN"
