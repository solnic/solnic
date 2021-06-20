---
title: "Cutting Corners or Why Rails May Kill Ruby"
date: "2015-06-06"
categories:
  - "blog"
tags:
  - "blog"
  - "rails"
  - "rant"
  - "ruby"
---

Today I’m tired and frustrated. And it’s not the first time that I have those negative feelings. Typically I just complain on twitter, lose some followers, wait a bit to calm down and move on.

But today I need to vent and convert my negative emotions into something constructive and hopefully meaningful to others. Every time I simply whine about certain aspects of Ruby ecosystem and especially Rails people are asking me specific questions that I fail to address properly. Mostly because of a lack of time and the fact twitter is a horrible medium for longer discussions.

So here it goes, this post is about what’s wrong with monkey-patching and the general rails mindset that I see as a potential serious problem which in the long term may simply kill Ruby.

## Cutting corners through monkey-patching

Yesterday I was pointed to a pull-request which adds `Enumerable#pluck` to ActiveSupport which was merged in, because why not? It’s definitely handy so let’s just add it. Besides ActiveRecord has this method and it’s so useful so why not just have it for all enumerables.

What Rails-affected people fail to see (which is easy given DHH is still so proud of ActiveSupport and continuously repeats that on many occasions) is that this is what you do when you introduce a monkey-patch:

![image](/assets/images/speed-tape-duct-tape-plane-444961.jpg)

Let’s analyze this: there seems to be a problem, maybe we know how to fix it properly but why bother spending time thinking about it and searching for good tools (or even worse - building them!) to properly fix it, and hey, we have a duct tape\[\*\], it’ll surely fix it for us and it’ll fix it _now_.

The airplane landed thus the author of this fantastic “solution” to a very specific problem claims duct tape is a great tool to fix this kind of issues.

This is what we’re doing with monkey-patches. We’re cutting corners and convincing ourselves it solves our problems for good.

\[\*\] it’s actually called [Speed Tape](http://en.wikipedia.org/wiki/Speed_tape) used for _temporary_ fixes, don’t freak out when you see it

## Addressing immediate needs doesn’t solve actual problems

Adding a monkey-patch is so easy with Ruby that it doesn’t even give you a chance to stop for a second and think. Why am I doing this? What am I trying to solve? What _kind of a problem_ is this monkey-patch going to solve? Is it part of a general big problem that could be isolated and solved in a well designed and encapsulated piece of code? Or is it just my immediate, domain-specific need to do something that it should stay isolated within my application’s namespace?

`Enumerable#pluck` maps an enumerable by returning values under specific keys ie `[{a: 1}].pluck(:a) => [1]` - this is handy, I have to admit. The problem here is that it doesn’t solve anything. It’ll make people pluck the values here and there which will result in a lot of accidental complexity which very often is completely unnecessary if you could only have a place in your system to transform data structures according to specific rules that your application’s domain dictates. What you do instead is that you apply an ad-hoc approach to programming - rather than solving specific problems and isolating them in order to reduce complexity you just use all those convenient monkey-patches in an inconsistent fashion.

What if you suddenly need something more sophisticated than a simple pluck? A Rails-infected developer would probably think about another monkey-patch, why not, right? In fact somebody actually criticized [my approach](/2015/04/16/introducing-transproc-functional-data-transformations-for-ruby.html) to data transformations in Ruby and said a monkey-patch, when done properly (whatever that means!), would be more elegant.

Identifying specific problems, isolating them from the others and solving them through simple, fast, coherent solutions is the only way to reduce complexity of our systems. Introducing monkey-patches is a short-sighted “solution” that only adds confusion and decreases cohesion of the systems we’re building with Ruby.

Stop. Doing. That.

## How does it affect us?

I see it as something that damages our entire ecosystem because lots of people, including those who are just getting into the community, are completely convinced it’s the way to do things in Ruby.

It’s definitely A way of doing things but is it a good way? I doubt that. No, scratch that. I _know_ it is not a good way and it is one of the biggest reasons why lots of Ruby libraries are poorly written because monkey-patching also reduces the need of having properly designed interfaces. When something can be monkey-patched, why would I introduce an interface to extend my library? Right.

We can’t continue building systems on top of mountains of monkey-patches like Rails. It decreases confidence, introduces additional complexity, teaches people to be ignorant about changes they make to the runtime, makes it very hard to properly identify real problems that we need to solve and the list goes on including very specific problems like, obviously, conflicting interfaces, very hard to debug bugs ending up realizing that something changed our code in an unexpected way etc.

Just last week people wasted time because of `Object#with_options` in ActiveSupport (literally two people stumbled upon that and asked me for help as they couldn’t understand why something is not working). I also really “enjoyed” debugging my code as something wasn’t working as expected just to realize that `Object#try` is another monkey-patch from `ActiveSupport` and I happened to implement `try` in my object with different semantics. Or how about [this series of monkey-patches](https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/object/to_query.rb) which adds methods like `NilClass#to_param` or `TrueClass#to_param` which is literally there just because Rails is a web-framework and happens to need those methods for `url_helper` (huh, helpers, that could be another rant). Those things fucked up my day more than once. I’m talking about many wasted hours in total. Just in my case and I’m _not the only one_.

## Rails May Kill Ruby

What!? I know right. In 2009 Uncle Bob gave [a talk](https://www.youtube.com/watch?v=YX3iRjKj7C0) at Rails Conf titled “What Killed Smalltalk Could Kill Ruby” and he said “it was too easy to make a mess”.

Now here’s something to think about: Rails is a massive mess, a mountain of monkey-patches, a framework that changes Ruby to make it fit better to its own needs. As my friend said “Rails assumes it is on the top of the toolchain”. Which is a very smart thing to say. The result of that is a damaged ecosystem and educating people to do things that end up damaging it even more.

The irony here is that 99% of Ruby developers became Ruby developers because of Rails. I’m just not sure if that has any actual technical meaning in this conversation. What are we supposed to do then? Praise Rails despite the fact many of us progressed as developers and realized many things in Rails are plain wrong?

Rails may kill Ruby because many smart people are leaving Ruby or have already left Ruby. I know many of those people and I already miss them. Somebody told me on twitter that it won’t happen, that maybe “just experts will leave Rails/Ruby”. I’m sorry but if a given technology makes experts leave it because of serious technical issues then I no longer understand what this is all about.
