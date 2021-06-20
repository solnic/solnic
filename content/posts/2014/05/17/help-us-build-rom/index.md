---
title: "Help Us Build ROM"
date: "2014-05-17"
categories: 
  - "blog"
tags: 
  - "blog"
  - "oss"
  - "rom"
  - "ruby"
---

Many people have been asking me how they can help us build [ROM](https://github.com/rom-rb/rom). This was the hardest question I’ve heard next to “when will it be ready?”. My usual reply was suggesting to join our IRC channel and talk but it really isn’t a good answer as it’s difficult and time consuming to talk about same things all over again that’s why I decided to finally put together this post and explain what’s going on and how you can help.

## What’s ROM?

ROM is a high-level interface built on top of [Axiom](https://github.com/rom-rb/axiom). It is still an experimental project and literally everything can be changed anytime. For the last couple of years we were focusing on the underlaying tools and libraries and it was hard to imagine how the actual high-level public interface should look like. We went through 3 prototypes and just recently things started to clarify as [Martin](https://github.com/snusnu) and [Markus](https://github.com/mbj) already used pieces of ROM in their projects and came up with ideas how things should be designed from the high-level interface point of view.

So, what is ROM? To put it as simple as possible - it is a library that gives you access to multiple databases using Axiom and provides domain object mapping using Morpher. In its current form it’s a DSL providing slightly more convenient way of using the aforementioned libraries.

Currently Martin is working on an alternative interface in a project called [ramom](https://github.com/snusnu/ramom) which explores interesting concepts like [“Relations as first class citizen”](http://www.try-alf.org/blog/2013-10-21-relations-as-first-class-citizen) - we both collaborate closely and it is very likely that ROM will incorporate a lot of the ideas from Martin’s work.

## What’s ROM Ecosystem?

You might’ve heard people referring to “ROM ecosystem”. This is how we called a small ecosystem that consists of many libraries that were created as a nice side-effect of building ROM itself. Those libraries are the foundation and we need help in maintaining them and building new ones.

We can categorize those libraries in 3 groups:

- Support libraries
    
    - [equalizer](https://github.com/dkubb/equalizer)
    - [abstract\_type](https://github.com/dkubb/abstract_type)
    - [memoizable](https://github.com/dkubb/memoizable)
    - [adamantium](https://github.com/dkubb/adamantium)
    - [concord](https://github.com/mbj/concord)
    - [ast](https://github.com/whitequark/ast)
- Foundational backend libraries
    
    - [axiom](https://github.com/rom-rb/axiom)
    - [axiom-sql-generator](https://github.com/rom-rb/axiom-sql-generator)
    - [sql](https://github.com/rom-rb/sql)
    - [morpher](https://github.com/mbj/morpher)
- Development tools
    
    - [mutant](https://github.com/mbj/mutant)
    - [devtools](https://github.com/rom-rb/devtools)

## Where do I start?

If you would like to get involved I suggest reading about all the projects in ROM ecosystem. Learn what they do, how they are implemented, see if there are any open issues on Github. You should be able to find something that’s interesting and simply start hacking on it. _Please do not hesitate to ask questions or provide feedback_.

Currently big focus is on the new SQL generator that’s based heavily on the [ast](https://github.com/whitequark/ast) gem. There are experimental forks of [sql](https://github.com/rom-rb/sql), [axiom](https://github.com/rom-rb/axiom) and [axiom-sql-generator](https://github.com/rom-rb/axiom-sql-generator) where all the work takes place. This involves adding `#to_ast` method to all axiom’s objects so that it can be translated to the sql ast. You can see a [WIP PR](https://github.com/rom-rb/axiom/pull/1) with a TODO. Maybe that’s a place where you could start helping us? Building axiom-sql-generator is also [quite interesting](https://github.com/rom-rb/axiom-sql-generator/commit/a899d80ac991e2038be6561f09c4db19c5f77295).

## Let’s chat!

Yesterday, as an experiment, I opened a rom-rb [channel](https://gitter.im/rom-rb/chat) on [gitter](https://gitter.im) to see if it can work better than our IRC channel. Please join and let’s chat. It has a really nice integration with github so that you can see what’s happening in ROM’s repositories. I really like that!

One last thing - if something is unclear and/or confusing please let me know. I would like to turn this post into a reference article for people who would like to get involved.

Thanks! <3
