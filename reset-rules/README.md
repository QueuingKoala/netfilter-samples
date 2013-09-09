Unloading netfilter rules the less-abusive way
==============================================

Overview
--------

In order to "reset" netfilter rules to a clean, default slate, it is necessary
to remove all the rules currently in place and reset policies to their default
ACCEPT state for built-in chains. The reality of the situation is that all the
"clever scripts" out there to do this don't know which tables are loaded into
the kernel.

Here's how to reset your netfilter rules the less-abusive (and more productive)
way.

What's the problem?
-------------------

I see too many people call iptables with -F, -X, and -P over and over, and this
has a number of problems. This method is:

  1. Slow

  2. Needlessly loads kernel modules for tables that weren't originally loaded

  3. Not atomic

     Failures to run one of the rules or typos will cause some of the commands
     to work while others fail. This is especially bad if the ACCEPT policy
     isn't set while all the rules that were previously accepting traffic are
     removed.

  4. Doesn't support tables people forget

     Many people forget the raw/security tables, and some forget nat/mangle.

If you're one of the people doing this, please stop.

Using this script
-----------------

This script looks at your iptables-save(8) output and sets any tables you have
loaded back to their defaults, then runs a single atomic operation through
iptables-restore(8). This is as clean as it gets short of writing your own
"blank.rules" file to restore yourself.
