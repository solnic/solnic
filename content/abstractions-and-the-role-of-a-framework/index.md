---
title: Abstractions and the role of a framework
date: '2016-05-30'
categories:
- blog
tags:
- archives
- blog
- rails
- ruby
slug: abstractions-and-the-role-of-a-framework
aliases:
- "/2016/05/30/abstractions-and-the-role-of-a-framework"
---

This is a follow-up to the discussion that was started last week after I published [“My time with Rails is up”](/2016/05/22/my-time-with-rails-is-up.html). Since this article received a lot of feedback, over 1000 comments on various sites and even more tweets, despite my greatest efforts, I didn’t manage to reply to everything. Many people were confused about some of the arguments, as I didn’t do a good job at providing proper context and making certain things clearer. This has caused incorrect interpretation of what I tried to explain.

Before I get to the actual subject of this post - abstractions and the role of a framework, I’d like to clear the air a little bit as many people, who were lacking my specific context, came to really bad conclusions.

First of all, **the post I wrote wasn’t anti-rails or anti-frameworks in general**. I explicitly wrote that Rails is here to stay and there are lots of good use cases for it, and probably most Ruby developers are still happy with Rails. Furthermore, I mentioned I’m helping with [the Hanami framework](http://hanamirb.org), I wouldn’t be doing that if I was anti-frameworks.

Secondly, the context of the article is important. I didn’t write it from the perspective of a Rails user who is switching to something else. I wrote it from a library author’s point of view _and_ a user too. I pointed out that **we need a more diverse Ruby ecosystem** so that we can address issues that Rails will never address, as they are not considered to be a problem by the core team. I voiced my concerns and I know there are many people in our community who feel the same way. In fact, based on the feedback I received, I feel even stronger about this now. So thank you <3

Last but not least, I noticed the “us vs them” attitude in many comments. I apologize if I created that impression myself. Rather than taking sides, let’s try to see how we can collaborate - **our goal is the same after all, we want Ruby to remain relevant**. If you have the energy to propose radical changes in Rails, go ahead - DHH told me they are always interested in feedback and having discussions. I don’t have that energy, as I’m too busy with a couple dozen other Ruby libraries, hence my decision to stop working with Rails and focus my time elsewhere.

OK, I hope this makes things clearer. Let’s talk about abstractions now.

## Abstractions

One of the reactions to my article was [“On the irony of programmers who don’t like abstraction”](http://eaf4.com/on-the-irony-of-programmers-who-dont-like-abstraction/), and this wasn’t the only one.

The role of an abstraction is to hide complexity, and it’s a good thing, no doubt about that. The problem arises when that abstraction has no solid foundation, and under the hood there are no re-usable, low-level abstractions. However, it’s easier said than done, Rails has been created _13 years ago_, it’s got massive adoption and refactoring is extremely difficult, because of the backward compatibility issues and having to deal with a huge codebase.

Finding a high-level abstraction (a DSL or a single-method interface, doesn’t matter) is _much simpler_ than figuring out lower-level abstractions afterwards. A typical evolution of a library is:

- provide a high-level abstraction
- provide more features
- realise you’ve got mess under the hood
- try to refactor into smaller, low-level abstractions
- fail or succeed

When you fail, you start over, some times in a new project. When you start working on a library you typically don’t have a 100% understanding of what you’re doing. It’s natural. In most of the cases you can’t really tackle it going bottom-up, because you’re knowledge is incomplete. Even when you try to start with low-level abstractions first, you may end up with _the wrong abstractions_. **And as a smart person once said - the wrong abstraction is worse than a lack of abstraction**.

Focusing on programmer ergonomics is extremely important for productivity, this is what Rails mastered; however, let’s not forget about low-level abstractions and spend time on discovering them. **Being able to use low-level abstractions will make you more productive in the long term**, but if you don’t have them, you will have to workaround the deficiencies of the high-level abstraction. The sql builder in [Discourse](https://github.com/discourse/discourse/blob/master/lib/sql_builder.rb) is a good example of struggling with an ORM because there’s no simpler, easy to use abstraction for constructing efficient queries.

Introducing low-level abstractions will decrease complexity of the code at the unit level, while at the same time it will _increase_ the complexity of the whole system, as you have more pieces communicating with each other. It’s like going from a monolithic single-app system to SOA, but at the library level.

## The role of a framework

Now that we know that high-level abstractions are as important as low-level ones, what’s the reason for having frameworks?

A framework is a collection of high-level abstractions, which reduces the amount of boilerplate code that a programmer needs to write, and it’s often based on specific conventions for its common usage. **The revolution started by Rails was Convention Over Configuration**, which allows you to use a framework with very little custom configuration. This set a new standard for framework creators, especially in the Ruby ecosystem, as it’s become the de facto standard.

Using a framework is typically a joyful experience in the beginning, as you’re using common functionality to implement common features. **Problems arise when you start to diverge from framework’s conventions** and there’s no custom configuration that can help you. This is the moment when you need to look at low-level tools, and if they don’t exist, you’ll be on your own.

That’s why it’s so important to have a framework that consists of loosely coupled components, where each component is a standalone system on its own. The more assumptions a framework makes about your application architecture, the bigger the risk of hitting a wall in the long term. Rails provides a simple example; it assumes that you use an Active Record, its Active Model interface is based on Active Record, routing helpers need it, many view helpers need it, 3rd party gems need it too. That’s a huge assumption and it comes with many trade-offs. On one hand it simplifies Rails itself, less abstractions are needed when you simply assume an Active Record. On the other hand using Active Record adds a lot of constraints to the way you can design your system. If Rails was truly ORM-agnostic, it would be much more complex internally, and its public APIs would probably become less convenient. This is a trade-off.

The role of a framework is to aid you in solving domain-specific problems, while at the same time keeping the doors to simpler abstractions open, as you _may_ need them in the future. **It’s hard to achieve that**, and programmer’s ergonomics may suffer a bit, but that’s a trade-off as well, as in the beginning the cost of usage might be a bit bigger, but it will pay off in the longer term.

## Where do we go from here?

It’s important to have a conversation about diversifying the Ruby ecosystem. **Ruby needs new frameworks and libraries built on top of solid abstractions**. These abstractions should provide services with which a developer can build applications suited to a diverse range of domains.

There are many projects that have been in the works for years already. If you’re interested in helping out, check out following projects:

- [The Hanami framework](http://hanamirb.org)
- [Trailblazer](http://trailblazer.to)
- [dry-rb](http://dry-rb.org)
- [rom-rb](http://rom-rb.org)

All these projects have [Gitter](https://gitter.im) channels, we’re having many interesting conversations there, and there are always many things you can help with!

If you’re working on something new too, please let me know - **Ruby needs this**.

Thanks to [Chase Gilliam](https://twitter.com/ChaseGilliam) for proof-reading!
