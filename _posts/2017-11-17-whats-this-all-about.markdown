---
layout: post
title:  "What's This All About?"
date:   2017-11-17 12:09:42 -0500
---

I'm going to kick off this blog with a description of this project. I'm sure
it'll change as we go, but we've gotta start somewhere.

First off, we're going to design a new networking stack. It will contain a lot
of similarities to what the world currently uses, but will be quite
incompatible. I intend to take inspiration from TCP/IP and the like quite
liberally, but in some places we'll choose to do things differently and in
others we'll leave behind some cruft. In order to verify this design, we'll
build up a simulation layer as well as the software for a number of appliances -
something roughly analogous to switches, routers, and clients, at least. Code
for these will be available [on
Github](https://github.com/thedufer/ocaml-networking-nodes).

What will the simulation layer look like? We're going to cut off the
complexities of most of OSI layer 1. In particular, we will leave behind the
difficulties of time and analog voltages, including bit-level synchronization.
We will simulate imperfections in our connections - bits getting flipped,
garbage between messages, etc. Bandwidth will only be limited by the processing
power available to the simulation. Code for this simulator will also be
available [on Github](https://github.com/thedufer/ocaml-networking).

While we're at it, this blog will be [on
Github](https://github.com/thedufer/networking-blog) as well, although I'm not
sure why you'd care.

Phew. I hope we didn't lose anyone yet. Next time, we'll dive right in with the
first steps on our simulation layer.
