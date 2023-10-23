---
title: TDD Is Fun
date: '2014-04-23'
categories:
- blog
tags:
- archives
- blog
- programming
- rails
- ruby
- tdd
- testing
slug: tdd-is-fun
aliases:
- "/2014/04/23/tdd-is-fun"
---

Today DHH published [a blog post](http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html) about TDD being dead (to him at least). It’s really not that surprising since from what I know (please correct me if I’m wrong) David’s experience is mostly based on building web apps with Rails. I get that, I really do. For me practicing TDD in a rails environment is much harder than when I work on my OSS libraries. There are many reasons why TDD in Rails is just a bit harder than it could be but that’s a big, separate subject. In this post I want to explain that TDD can be fun!

## It’s not as strict as you think

There are many _guidelines_ in TDD. That you should focus mostly on unit testing. That you should be using mocks and stubs in isolated unit tests. That you should have contract tests. And so on. That list can be pretty long.

Those are guidelines, they make _a lot of sense_ and personally I found them to be useful but for me, when it comes to the core of TDD…it’s this:

**Write a test that describes expected behavior of your system and make it pass.**

Yes, that’s it. That’s how your journey begins. It doesn’t have to be a unit test. It can be an integration test. It can be an acceptance test (which is great when building web apps!). You simply _know_ what kind of test you _are able_ to write at a given point in time based on your current knowledge. This knowledge will be expanding as you go through red/green/refactor cycles. You will see missing interfaces, you will be able to introduce new objects and test-drive them from the start because after few refactorings you will know, trust me, you _will know_ how they should look like.

That’s how tests are guiding you, that’s how you’re designing your system based on the feedback of your tests. It’s a process, a journey that involves many small refactorings. You don’t stop after making your first test pass. You move on and discover missing pieces of the puzzle. It’s a lot of fun and it gives you great confidence that the code you just wrote works exactly like you want.

## Unit testing

It seems like DHH confuses unit testing with TDD. Unit testing is part of TDD and it’s a very crucial part. Most of the nastiest, hardest to fix bugs exist because of a poor unit test coverage. That’s a fact.

Some people are afraid of unit testing though and this is also not that surprising. It’s mostly because the cost of maintaining a big unit test suite is high. It’s very easy to spend a lot of time writing many small, focused unit tests that soon turn out to be obsolete and that _hurts_ a lot.

I think this happens because of two reasons:

- Writing unit tests too early
- Using mocks and stubs prematurely

We’ve been told that a unit test excercises a unit in complete isolation from the surrounding environment especially its dependencies. That’s a really nice concept and it works very well. But…you really need to feel confident about what you’re doing before you introduce unit tests. This can be achieved rather quickly after 1 maybe 2 red/green/refactor cycles after making some higher level test pass. You will see missing abstractions and you will know what kind of an interface you want to have. That’s a great moment to start writing unit tests.

There are also cases where you’re just prototyping something. This is really a bad moment for unit testing.

Another pain-point in unit testing that probably discouraged DHH is using mocks and stubs. If you do things “by the book” you would immediately start mocking dependencies and stubbing various method calls. For me it never works like that. Sometimes I would mock an interface as soon as I discover it. Another time I would just wait with mocking until I feel really confident that a given collaborator object shouldn’t be treated as an internal implementation detail. There are _many_ guidelines here as well, learn about them and keep them in mind but don’t follow them strictly all the time.

## It’s fun but it takes time to learn

You can’t buy a book about TDD and learn it in a month. It takes a lot of time and that’s why trying to be very strict about various TDD guidelines (especially the ones about unit testing) will be frustrating.

This doesn’t change the fact TDD is a lot of fun. Just be cool with it. If you manage to teach yourself to write tests first, you already gain a lot. Break the rules whenever you feel they are blocking you or slowing you down. If you broke a rule and ended up with problematic code you’ll at least learn why following that rule in a given context is a good idea.

Chill out, doesn’t matter if you get things right during first or fifth attempt, the process is all that counts. Write a test, make it pass, look at the code and take it from there.
