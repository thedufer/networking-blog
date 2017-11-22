---
layout: post
title:  "A Little More Realistic"
date:   2017-11-19 09:43:05 -0500
---
Last time, we got a basic network simulator working. Now we'll make the
connections a bit less perfect, and come up with a protocol that allows us to
still get messages across.

### Flipped Bits

First we'll add a little noise. This one is simple enough - we'll just flip
occasional bits. I've chosen arbitrarily to flip each bit with a .01% chance.

### Noise Between Messages

Next we'll add some noise when we're not using the connection. Each time we get a message to send, we'll add some random bits on either end of it.

### Unknown Windowing

Finally, the receiver of a message shouldn't be able to tell where it begins and
ends just because our interface happens to batch up bits. To obscure the message
lengths we'll just batch messages into regular-sized chunks.

### Layer 1 Protocol

Now that we have connections that are more difficult to work with, we need to be
a bit smarter to get bytes across. The protocol needs to solve two problems - it
needs to figure out the framing of messages, and it needs to detect errors so we
can drop bad messages.

Note: although we're calling this layer 1, it will correspond to parts of layer
1 and parts of layer 2 in the OSI model.

Let's figure out framing first. To find the beginning of the message, we'll just start messages with a fixed bit sequence, which the receiver can scan for. Finding the end is even easier - we will follow up the fixed bit sequence with a number representing the length of the payload.

Next we need to do some error detection. This is easy enough to do by appending a checksum to the end of our message. There's plenty of literature on checksums, so after some research I chose CRC-32. This has the nice properties that it is aimed at detecting the types of errors expected from network transmission, and the result is a fixed length.

Putting these things together, we end up with the following protocol:

| Preamble | Length  | Payload       | Checksum |
|---
| 4 bytes  | 2 bytes | 0-65535 bytes | 4 bytes  |

To recap, this allows us to send discrete messages of up to 65,535 bytes, with
reasonable confidence that messages received contain no errors. However, we will
drop any message that does contain errors.

There is a command implementing this protocol in my example node implementation
under the name "layer-one". It sends each line of input as a message.

### Next Up

Now that I've exhausted my supply of prepared code, the next post won't be for a
little while. For next time, I'm hoping to solve the problem of transmitting
messages across a local network larger than a single connection, by using
switches on non-endpoint nodes. We'll add persistent addresses (analogous to MAC
addresses) to each node to help with this.