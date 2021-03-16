---
layout: post
title:  "Perfect Networking"
date:   2017-11-18 12:10:37 -0500
---

To get started, we need to get this network simulator working. Let's talk
about how it'll work at a high level.

Our simulated networks will be simple - each node will contain N ports, and each
connection connects exactly 2 ports together and grants bidirectional
communication. When a node wants to send data, it passes a list of bytes and a
port number. If there is no connection on that port or the other end is turned
off, the bytes are dropped. Otherwise, they are transmitted as-is.

Obviously this is pretty unrealistic, but it's a good place to start. In the
future, we'll add some more features, like making the connections more realistic
and assigning each port/node pair a persistent address.

### Simulator

The simulator consists of a few different parts. First there's the server, which
accepts connections from programs representing the nodes and shuttles data
around. Second is the client, which can be used to interact with the server for
the purposes of changing the network structure (adding/removing nodes and
connections). Finally, a library will be exposed for writing node programs.

This can all be found on [Github](https://github.com/thedufer/ocaml-networking).
`bin` contains the source for the client and server, while `src` contains the
library code.

### Library Interface

While there is quite a bit of code in that library, clients should need very
little of it to get started. In particular, there is one function that allows a
program to declare itself as a node:

{% highlight ocaml %}
val connect
  :  Node.Id.t
  -> (Message.t Pipe.Reader.t * Message.t Pipe.Writer.t) Deferred.Or_error.t
{% endhighlight %}

This does the work of connecting to the server and setting up a pipe in each
direction for data. Its only argument is the identifier representing the node it
would like to act as, which can be thought of as a string.

A `Message.t` is just a record with a bunch of data, and an int representing
which port the data came in on:
 
{% highlight ocaml %}
type t = {
  port : int;
  data : char list;
}
{% endhighlight %}

Ports are simply numbered starting from 0 on each node.

### Simple Example

As an example, we'll create a network with 3 nodes, all connected in a circle.
The first step is to start the server:

{% highlight bash %}
sdn-local server init
sdn-local server run-server
{% endhighlight %}

Next, we'll set up the network:

{% highlight bash %}
sdn-local client add-node A 2
sdn-local client add-node B 2
sdn-local client add-node C 2

sdn-local client add-connection A 0 B 0 -perfect
sdn-local client add-connection A 1 C 0 -perfect
sdn-local client add-connection B 1 C 1 -perfect
{% endhighlight %}

Note the `-perfect` flag for the connections, which we've added so this will
continute to work when the default is something more realistic.

Finally, we can use the `sdn-local client print-dot` command to get a graph of
our network:

![a simple 3-node network]({{ "/assets/simple-network.png" | absolute_url }})

There is a command in my example node implementation called `passthrough` that
connects stdin/stdout to a single port, which can be used to see the network in
action.

### Next Up

Next time, we'll introduce some imperfections to these connections to get us
closer to something real-world.
