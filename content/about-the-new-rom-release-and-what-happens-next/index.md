---
title: About the new ROM release and what happens next
date: '2014-11-24'
categories:
- blog
tags:
- archives
- blog
- orm
- oss
- rom
- ruby
slug: about-the-new-rom-release-and-what-happens-next
aliases:
- "/2014/11/24/about-the-new-rom-release-and-what-happens-next"
---

Last month I [wrote](http://solnic.codes/2014/10/23/ruby-object-mapper-reboot.html) about rebooting ROM project and today I’m very happy that after almost 300 commits I pushed Ruby Object Mapper 0.3.0 to rubygems.org. It’s a big milestone as the project enters a new path and ships with a complete support for SQL databases thanks to Sequel. More official and less personal announcement is right [here](https://groups.google.com/forum/#!topic/rom-rb/xZfFYG1CYFs).

In this post I’d like to give you more insight into what’s happening with the project and how its development is going to be organized and why. Let me start by saying that I’m very inspired by recent posts on [Rubinius blog](http://rubini.us/2014/11/10/rubinius-3-0-part-1-the-rubinius-team/). Brian mentioned a couple of things I’ve been thinking about myself for a long time and it was amazing for me to read such a beautifuly written articles that talk about diversity in OSS community and the nature of building and releasing software. If you somehow missed those posts I highly recommend reading them.

## Contributions

Building a big open-source project like ROM is an effort that requires help from many different people. There are lots of things to work on from core rom library, through support tools and various database adapters. Input from different people helps a lot in keeping the right perspective too. Over time it’s easy to lose that perspective and start having trouble with seeing even the most obvious things. We can all learn a lot from each other and working on OSS projects is probably one of the best ways of sharing knowledge, experience and enthusiasm too!

I’ve noticed that after spending a lot of time working on a particular piece of software it’s dangerously easy to become defensive whenever somebody questions or criticizes what you do. I experienced that myself and I don’t want to be there again. The remedy (at least in my case) is to work with different people with different backgrounds, share your experiences and inspire each other.

Having said that - from now on commit access policy in ROM will be the same as in Rubinius.

**One PR merged in and you’ve got the commit bit**.

ROM already got contributions for this release and I’m very grateful for that! Thank you!

## Versioning

I used to think that version 1.0.0 must be an epic milestone that you reach once you’re perfectly happy with the code, all the features you wanted to have are implemented and the API is stable. What I failed to realize is that once something is good enough to be used on production then it means it should be 1.0.0 already.

Currently ROM is still a beta software and everything can change anytime; however…

**ROM will be tagged as 1.0.0 as soon as it’s used in production systems and then will strictly follow Semantic Versioning**.

It’s hard for me to precisely describe what will be included in 1.0.0 that’s why milestones on github issues are gone. I will add them again _after_ 1.0.0 is done as it will be much easier to think about the scope of future versions and prioritize tasks.

## Rough Agenda

The biggest focus is on SQL support simply because I use it at work and I’ve got greater motivation to work on it. This doesn’t change the fact other adapters for other databases are planned and there’s already a [mongo db](https://rubygems.org/gems/rom-rb/rom-mongo) adapter in the works. If somebody is interested in building a new adapter and it turns out some changes need to be made in ROM to support it then I’ll drop everything I do and help right away.

ROM integrates very nicely with [Virtus](https://github.com/solnic/virtus) which means it’s already a very powerful mapping solution that’s why I don’t plan to spend much time on the mapping part. Before 1.0.0 I also want to introduce a new interface for data manipulation (create/insert/delete operations) which is the only big addition that’s pending. There will be a couple of small but significant new features focusing on making it simpler to build complex queries too as right now it’s still too barebone.

But today please give it a try, I really appreciate your feedback! Ping me on [twitter](https://twitter.com/solnic29a) or [gitter](https://gitter.im/rom-rb/chat) if you have questions :)
