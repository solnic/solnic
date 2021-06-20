---
title: "Ditch Your ORM"
date: "2015-09-18"
categories:
  - "blog"
tags:
  - "blog"
  - "fp"
  - "immutability"
  - "oop"
  - "orm"
  - "oss"
  - "ruby"
---

I’ve been promoting a functional approach in Ruby for a while now and even though it includes many different techniques and patterns, there’s this one idea, one fundamental idea that changes everything - immutability.

But what does it even mean in Ruby? To freeze everything? That would be too slow, so no. Immutability-oriented design means that you avoid interfaces that can change your objects. Yes, there are plenty of methods in Ruby to mutate something, but when _you_ are designing your object interfaces, you _can_ design them in a way that your objects won’t change.

Using immutable objects has been an eye-opening experience for me. One of the things that it made me understand better is why object-relational mapping is such a bad idea and a reason why we have so much unnecessary complexity.

I’ve been a user of various ORMs for about 10 years, which includes ~2 years being on the Data Mapper project core team and ~2 more years trying to build its next version, which was meant to solve all the hurdles that comes with the Active Record pattern. I’ve seen it from the outside, I’ve seen it from the inside; and I don’t want to deal with any ORM headaches anymore. Enough is enough.

I ditched my ORM.

## Complexity

When building software; we should be focusing on reducing complexity as much as possible.

**Object-relational mapping is nothing but a layer of additional complexity that exists just because we want to mutate objects and persist them in a database.**

This stems from the fact that one of the core ideas behind OOD is to introduce abstractions that represent real world concepts, so that it’s easier to reason about our code, it’s easier to understand it. We’ve been stuck with this concept for so long that many people have trouble looking outside of this box.

You can still design your objects in such a way that it’s easy to understand what’s happening without having “a user that changes its email” or “an order that you add products to”. Instead of creating objects that represent **things** like a user or an order, try to think about how to model business transactions, domain-specific processeses.

Hint: realize that everything can be modeled as a function that simply transforms data

## The Impedance Mismatch

The complexity behind object-relational mapping is directly caused by something we call the object-relational impedance mismatch. It’s an insanely complicated problem to solve as there are many different database models and many different ways to represent objects.

You have two options here:

1. Agree to have a 1:1 mapping between database model and your domain objects
2. Use some sophisticated ORM system that would know how to map database representation of your objects into their in-memory representation in a given programming language

And both options are terrible.

First one is especially terrible, and many people in Ruby community know why, because 1:1 mapping tightly couples your application layer with the database. We’ve been using Active Record ORMs long enough to know how much it increases complexity of our applications.

What about the second option, typically known as the Data Mapper pattern? We don’t have that in Ruby, there are still people who are trying to build it and some projects already exist that try to implement this pattern.

**The reality is that we are not even close to solving the ORM impedance mismatch problem.**

The worst part is that you can’t truly solve it, you can only make it as good as possible, given the constraints a given programming language has. And then people will end up writing hand-written SQL anyway.

## There Is No Database?

![](/assets/images/photo_movieMatrix-quoteSpoon.jpeg)

Except there is. In fact, it’s one of the most powerful pieces of your stack. Now think about this for a second:

**We are going to pretend there is no database so that we can mutate our objects and persist them**

I know, it’s not what you’ve learned, typically we talk about wonderful things - like “proper abstraction so that our database becomes an implementation detail” or “it’s going to be easier to switch databases” or “objects are decoupled from the database so it’s easier to grow the system” and so on.

But what it really, trully boils down to is “I want to mutate my objects and persist them”.

What if I told you that you can still decouple domain logic from persistence details while, at the same time, avoiding the whole complexity that comes with ORMs and mutable objects?

Two magic words: **functions** and **data types**.

## There Is No User

This is no `User`, there is no `Order`.

There is no `ActiveProductShippingContainerHolyMolyManager`.

There’s only **a client** sending **a request** to your **server**. The request contains data that the server uses to **transform** that data into a **response**.

The closest we can get to model this interaction is **a function that takes an input and returns an output**. In fact, it’s always a series of function calls that eventually returns the response.

Once you realize that you will see that there is absolutely no need to come up with awkward abstractions that we’ve grown to be completely comfortable with, for some reason.

What about the data? Data means complexity so we hide that behind objects, right? Except that it never really worked like advertised.

**Mixing messy data with messy and unpredictable behavior is what ORM really means**

But how? Why?

It’s messy because we don’t define precisely what **data types** our application is dealing with. We’re perfectly happy to pass raw data input straight to our ORM layer and hope for the best. It’s unpredictable because objects are mutable, and with mutability come hard to predict side-effects. Side-effects cause bugs.

Imagine you could define **a user data type** that would guarantee that invalid state is not possible. Imagine you could pass that data type from one place to another to get some response back without having to worry about side-effects. You see where [this is going](https://en.wikibooks.org/wiki/Haskell/Type_basics), right?

Using functions and data types is a much simpler and way more flexible approach to model client-server interactions than any typical OO with mutable objects you’ve ever seen.

There is no `User` but it’s very likely there is `SignupUser`. There is no `Order` but you definitely can deal with `PlaceOrder`. And when you see classes ending with `Manager` - just run.

## What Choice Do We Have?

I believe one of the biggest misconceptions of our modern OO times is this:

**“I need an ORM because I use an OO language”**

Do you? You actually don’t! What you do need is a way to fetch data from your database and a data transformation layer so that it’s easy to transform domain data types to persistence-compatible ones.

And that removes heaps of unnecessary abstractions that come with typical ORMs.

**You can still use objects to model interactions between a client and a server but there’s no real need to have mutable objects**.

OO languages that can support that will live longer.

My style of programming in Ruby has changed drastically over the last few years. Ditching ORM was one the best decisions I’ve ever made. It’s the reason why I work on [Ruby Object Mapper](http://rom-rb.org) and talk about this at conferences. It may be against what’s common, what’s idiomatic, but when what’s common and idiomatic has been failing me for so long, I don’t see any reason why I should continue going down this rabbit hole - I definitely don’t want to see how deep it goes.

The truth is, FP communities are ahead of their OO equivalents already. The best we can do is to learn what great paradigms from the FP world we can take and apply in our OO code, so that it serves us well. For me it’s moving away from ORMs and mutable objects.

**Ditch your ORM. Embrace immutability-oriented design. It works better.**
