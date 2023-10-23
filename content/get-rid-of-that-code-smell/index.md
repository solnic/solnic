---
title: Get Rid of That Code Smell
date: '2012-03-30'
categories:
- blog
tags:
- archives
- blog
- datamapper
- metrics
- ruby
slug: get-rid-of-that-code-smell
aliases:
- "/2012/03/30/get-rid-of-that-code-smell"
---

While working on DataMapper 2 libraries we are measuring quality of our code with various code metric tools. [Dan Kubb](https://github.com/dkubb) has been using this approach successfully for over 2 years in [Veritas](https://github.com/dkubb/veritas) which resulted in a beautiful and clean code. When I started working on [Virtus](https://github.com/solnic/virtus) I decided to embrace all the practices that Dan introduced in his projects. It was a fantastic experience because Virtus was not a green-field project - I extracted a piece of DataMapper 1 and turned it into a standalone library. The code was already pretty awesome and easy to work with but this didn’t change the fact that most of it was completely refactored after we realized how many code smells were there. Based on this experience I’m starting a small series of blog posts about dealing with various common code smells.

There are a lot of great ruby tools for finding smells in your code. In DM2 projects we use [metric-fu](https://github.com/jscruggs/metric_fu "metric-fu on github") which incorporates usage of Flog, Flay, Reek and Roodi. Recently I also started experimenting with [Pelusa](https://github.com/codegram/pelusa "pelusa on github") (I’m hoping to replace _all_ the metric tools with Pelusa at some point in the future).

Here’s a list of most common code smells that we’ve identified and removed:

- [Attribute](http://solnic.codes/2012/04/04/get-rid-of-that-code-smell-attributes.html "Get Rid of That Code Smell – Attributes") (using attribute getters/setters)
- [Control Couple](http://solnic.codes/2012/04/11/get-rid-of-that-code-smell-control-couple.html "Get Rid of That Code Smell – Control Couple")
- [Duplication](http://solnic.codes/2012/05/11/get-rid-of-that-code-smell-duplication.html "Get Rid of That Code Smell – Duplication")
- [Primitive Obsession](http://solnic.codes/2012/06/25/get-rid-of-that-code-smell-primitive-obsession.html "Get Rid of That Code Smell – Primitive Obsession")
- Feature Envy
- Utility Function
- Large Class
- Long Method

In the near future I’ll describe each of these code smells with simple code examples showing you how you can deal with them. This will show what we’ve done but I’m not saying that there are no better ways and as always I’m open for discussions.

What’s the result of removing these (and probably a few more that I don’t recall at the moment) code smells? Really clean and well designed codebase that’s a great pleasure to work with. You can actually see a visual result on Virtus’ CodeClimate profile [here](https://codeclimate.com/github/solnic/virtus "Virtus on CodeClimate"). Entire codebase has “A” grade. How awesome is that?

If you want to know how we’ve pushed Virtus to the high level of code quality - watch this space.
