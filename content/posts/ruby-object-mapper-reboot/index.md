---
title: Ruby Object Mapper Reboot
date: '2014-10-23'
categories:
- blog
tags:
- archives
- blog
- orm
- oss
- ruby
slug: ruby-object-mapper-reboot
aliases:
- "/2014/10/23/ruby-object-mapper-reboot"
- "/ruby-object-mapper-reboot"
---

Rewrite is done. You can read more about it [here](http://solnic.codes/2014/11/24/about-the-new-rom-release-and-what-happens-next.html).

I’d like to let you know that after a couple years of work and a lot of thinking I decided to “reboot” [ROM](https://github.com/rom-rb/rom) project. This decision was not easy and it has a lot of implications but it’s going to be awesome. Here’s why.

## New philosophy, similar goals

If you’ve been following the project you know that the effort started as the next major version of [DataMapper](https://github.com/datamapper/dm-core) and then was renamed to ROM. There were a couple of big features we always wanted to have like a common interface for accessing different types of databases through a library called [Axiom](https://github.com/dkubb/axiom). Axiom is an amazing piece of software unfortunately nobody had the time to finish it which effectively blocked evolution of ROM itself. Another problem was that it required a multi-layered architecture to make all the pieces work together which is just a lot of complexity.

Over the last couple of years I learned that embracing simplicity when building software is essential for me. I try to be very careful when choosing 3rd party software and avoid unnessesery complexity as much as I can. That’s why I want ROM to be as simple as possible and levarage existing database-access libraries with a minimum effort.

This practically means _ROM won’t be based on Axiom_ and will use a thin adapter layer on top of existing database-access libraries.

The most important goals are the same:

- Support for different types of databases
- Mapping data to domain objects
- Combining data from multiple databases in memory

In addition to that ROM will encourage a slightly different approach to working with data by:

- Exposing relations as 1st-class citizens within your app
- Exposing _a simple_ and _consistent_ interface for manipulating data
- Discouraging direct access to lower-level query interfaces on the application level

Oh and one more thing - it _will be lightning fast_.

## The work already started and you can help

Earlier this week I already started rebuilding ROM. I added a new adapter interface and reimplemented everything from scratch keeping a lot of ideas the same and adding a couple of new features. RDBMS support is now done thanks to the fantastic [Sequel](http://sequel.jeremyevans.net) library. Before releasing next version I’d like to add a redis adapter just to prove things can work together with different databases. You can check out the [README](https://github.com/rom-rb/rom#ruby-object-mapper) to see how the interface looks like.

The [issues](https://github.com/rom-rb/rom/issues) describe what needs to be done and I will do my best to keep this up to date so feel free to ask questions there. If you have ideas about some potential new features please report them there and we can discuss.

You can also find me on [Gitter](https://gitter.im/rom-rb/chat) where we can talk about all the nitty-gritty details.

## Thank you

I want to thank [Dan Kubb](https://github.com/dkubb) for his amazing and inspiring work on Axiom. I also want to thank [Markus Schirp](https://github.com/mbj) and [Martin Gamsjaeger](https://github.com/snusnu) for all the efforts they’ve put into many libraries that ROM is still using. I wouldn’t be where I am now if I didn’t meet you.

So, the journey continues :)
