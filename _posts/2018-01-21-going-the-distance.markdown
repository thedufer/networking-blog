---
layout: post
title:  "Going the Distance"
date:   2018-01-21 21:02:46 -0500
---
This time we want to get messages across a small network, rather than just a
single hop. In order to do so, we'll add a globally unique address to each node,
design a protocol for addressing messages, and then build some software to run
on the intermediate nodes.

In the end, instead of needing a fully connected graph like we did with our last
protocol, we'll be able to get away with simpler graphs - at the cost of
additional nodes, since non-edge nodes will be reserved for acting as switches.

### Addresses

Each node will be given an address, which is simply a 64-bit number. They are
assigned by the simulation server - in real life, they might be assigned by a
manufacturer, like MAC addresses. This allows us to assume that they're globally
unique.

### Layer Two Protocol

For this layer, we simply need to tack addresses onto each message. Although we
won't use it just yet, we'll put the source address as well as the destination:

| Destination Address | Source Address | Payload       |
|---
| 8 bytes             | 8 bytes        | 0-65519 bytes |

Finally, we'll wrap this in a layer one packet. This is where the length
restriction on the payload comes from - remember, our layer one protocol only
allows for payloads up to 65535 bytes, and we've taken up 16 of them with
addresses.

### Switches

A "switch" is a non-edge node at this layer. Switches are quite simply - they
connect to one or more other nodes, and simply send every message they get on
any port to all of the ports. This requires very little knowledge of the
network, which allows the switch to be quite simple.

This will cause a significant increase in the amount of traffic. Edge nodes will
need to filter out messages that aren't addresses to them. Next time, we'll talk
about some ways to cut down on the traffic by making our switches a bit more
clever.