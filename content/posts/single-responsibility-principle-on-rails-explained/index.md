---
title: Single Responsibility Principle on Rails Explained
date: '2012-07-09'
categories:
- blog
tags:
- archives
- blog
- oop
- rails
- ruby
- solid
- srp
slug: single-responsibility-principle-on-rails-explained
aliases:
- "/2012/07/09/single-responsibility-principle-on-rails-explained"
- "/single-responsibility-principle-on-rails-explained"
---

A few weeks back we had a small drama about SRP. There were some smart comments, some stupid ones and a few funny jokes even, like that for example:

https://twitter.com/porras/status/220456288017059840

If I remember correctly it all started with [this post](http://www.naildrivin5.com/blog/2012/06/10/single-responsibility-principle-and-rails.html). I’ve seen criticism on twitter saying that the post shows shitty code, that it’s more complex than it should be, that User class is definitely the best place to put code that creates a user and so on.

My general reply to this was that it is really hard to explain OO principles in a blog post with a few short code examples. The benefits of following SOLID and other principles are clearly visible after your project reached a certain level of complexity. When you start a new project and you immediately want to start rigidly applying things like SRP then your code will probably look awkward.

In this post I’ll try to explain my approach to SRP and what I do to follow that principle in a non-extreme but pragmatic way.

## Understanding What Responsibility Is

First of all “responsibility” is a flexible term and it should be treated this way. You need to keep redefining it depending on the current state of your project. I like to think that the more complex your project becomes the more narrow the definition of responsibilities should be. What do I mean by that? It’s simple. Let’s use the example from the mentioned post: creating a user. This can be a trivial thing to do, a matter of 1 line of code in Rails. If that’s the case would you say that creating a user must be treated as a single responsibility? Hmm I don’t think so. It’s very likely that when you start a project then entire CRUD for User is trivial, basic operations handled by Rails itself without any work from your side. In such cases I think that CRUD can be treated as a single responsibility. It is, in fact, a pretty wide definition of responsibility but that’s ok since what we do is very basic.

To get it right and to avoid overcomplicating your code you need to pay close attention to the requirements of your project. Every time you need to add a new method or dependency to a class it will be reflected in your tests as they will become more complicated. If you do TDD then you will immediately notice that moment when a class becomes too complex and it should be broken down. If you don’t do that then you have a problem because you will notice overly coupled and complicated code _eventually_ but it’s going to happen _way later_ than if you did TDD from the beginning.

## Narrowing Down Responsibility

If creating a user must involve things like sending out notification emails then it’s definitely a good reason to narrow down our definition of responsibility as now we have 2 responsibilities: saving user data in the database and sending notification email. We have a user class responsible for the former and a mailer class for the latter. If you add an after_create observer it will have the same effect as if you added an after_create hook to your User class. Having a standalone, explicit service class that handles creation of a user and sending a notification email is a better option.

It’s not exactly The Rails Way, I know, then I why is it better? It’s better because the code is nicely decoupled as each object is responsible for just one thing. User knows how to persist its data, Mailer knows how to send a notification email and “User Creator” service is responsible for this special case when we want to create a user and have a notification email sent. In your tests you don’t have to care about turning off observers, you always have an explicit way of creating a user without any side effects. You also have an explicit way of creating a user and sending a notification email. There are no “magic moments” in your code when some observer does something special. It’s all explicit, decoupled and easy to change.

## Redefining Responsibilities

As your project evolves you will have to redefine various responsibilities. It’s not that hard especially when you do TDD. Here’s a short list of things that can help you in defining and redefining responsibilities:

- Write pure unit tests isolated from Rails - this reveals object responsibilities, pay attention to number of methods and their length
- In your isolated unit tests explicitly require dependencies - this will show you if a class depends on too many things and probably should be broken down
- Watch carefully if test setup doesn’t become too complicated - setting up 10 mocks just to test one method? That means SRP is probably violated
- Document your classes and methods - you should always be able to describe what your code does in a short sentence

Try following these guidelines and you shouldn’t have problems with defining **and** redefining responsibilities and it should help in following SRP in a sane way.

## Summing Up

SRP is not about having 100 single-method classes in your code base. It’s about decoupled code that’s easy to change and extend. It’s your job to make sure SRP is not violated in a way that causes tight-coupling. You need to be sensitive to every addition to your classes. Every time you add a method to a class try to think if it’s maybe not that moment where “responsibility” should be redefined and narrowed down.
