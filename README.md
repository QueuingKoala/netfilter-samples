Overview
========

These sample netfilter rulesets demonstrate usage for various setups and common
tasks. The goal in each example is to supply a simple and efficient ruleset that
can be extended upon as required.

Please do not use this examples without reading through the ruleset and
understanding the logic behind it; many of the intended features are included as
comments to show usage; you (the reader) should make sure the completed ruleset
operates as required for your particular environment.

Note that this is not intended as a "guide" to using netfilter. These are
simplified basic rulesets that can provide a starting point and sample
configuration for a variety of needs.

Structure
========

Each named directory includes a description of the ruleset included within. The
rulesets themselves contain some comments inline, and may optionally include a
separate readme document that details some specific features that are too
verbose to be easily included in the ruleset comments.

Using Rulesets
==============

The rulesets are all in iptables-save(8) syntax, which means they can be loaded
through iptables-restore(8). Alteration may well be required for use in your
environment, so verbatim use is not recommended. These are intended as learning
guides to demonstrate a highly efficient netfilter structure while promoting
modification.
