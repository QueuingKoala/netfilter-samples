Overview
========

Sample Netfilter rulesets and utilities can be found here.

These rulesets demonstrate usage for various setups and common tasks. The goal
in each example is to supply a simple and efficient ruleset that can be extended
upon as required.

Some useful Netfilter utilities are also provided.

Netfilter Utilities
-------------------

The following utilities are found in the listed dirs; each has a further Readme
with more information.

 * `iptables-failsafe` -- An improved way to load rules with automatic rollback
   in the event of failure (with benefits over using `iptables-apply`)

 * `reset-rules` -- A method to clear out currently loaded tables to the
   kernel-default for those tables. Note that restoring a "blank" ruleset is a
   cleaner solution, but that requires you have one ahead-of-time.

Netfilter Ruleset BNF
---------------------

The `netfilter-ruleset-bnf` directory has a BNF description and documentation of
the `iptables-restore` (also `iptables-save`) ruleset format.

Ruleset Samples
---------------

Please do not use these examples without reading through the ruleset and
understanding the logic behind it; many of the intended features are included as
comments to show usage. You (the reader) should make sure the completed ruleset
operates as required for your particular environment.

Note that this is not intended as a "guide" to using netfilter. These are
simplified basic rulesets that can provide a starting point and sample
configuration for a variety of needs.

### Ruleset layout

Each of the `rules-*` dirs includes targeted example rulesets. The rulesets
themselves contain some comments inline, and may optionally include a separate
readme document that details some specific features that are too verbose to be
easily included in the ruleset comments.

### Using Rulesets

The rulesets are all in `iptables-save(8)` syntax, which means they can be
loaded through `iptables-restore(8)`. Alteration may well be required for use in
your environment, so verbatim use is not recommended. These are intended as
learning guides to demonstrate a highly efficient netfilter structure while
promoting modification.

### Overview of ruleset dirs

 * `rules-edge-router` -- a basic edge/border router protecting a LAN
 * `rules-host` -- a basic ruleset for a single host
