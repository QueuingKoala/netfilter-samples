iptables-failsafe README
===

iptables-failsafe is a smarter way to apply new Netfilter rulesets.

License
---

This code is available under a GPLv3 license.

Copyright 2013 Josh Cepek <josh.cepek@usa.net>

Purpose
---

The `iptables-apply` command leaves in table/COMMIT blocks that applied
successfully, only reverting the current block in the event of failure.
Depending on the rulesets, this could have unintended consequences.

This script fixes that problem by reverting the *entire* currently loaded
ruleset in the event of a rollback situation.

Usage
---

Call with:

    ./iptables-failsafe.sh [-6] [-t <sec>] <ruleset>

where:

 * `-6` loads an IPv6 ruleset
 * `-t <sec>` alters the default failsafe timer (in seconds)
 * `<ruleset>` is the path to the ruleset to load

Note about failsafe operation
---

In order to completely fallback to the old ruleset, it is **required** that the
currently loaded ruleset have all the tables present that are in the new
ruleset. If you don't, then any rules applied by the new ruleset will stay and
*not* get reverted.

The best way to ensure this is to load all 4 basic tables prior to calling this
script. (Advanced users may need `security` loaded too, but that's not common.)

 * `filter`
 * `mangle`
 * `raw`
 * `nat`
