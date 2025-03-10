---
title: 8 Things I Learned During 8 Years of Ruby and Rails
date: '2015-03-04'
categories:
- blog
tags:
- archives
- blog
- personal
- rails
- ruby
slug: 8-things-i-learned-during-8-years-of-ruby-and-rails
aliases:
- "/2015/03/04/8-things-i-learned-during-8-years-of-ruby-and-rails"
- "/8-things-i-learned-during-8-years-of-ruby-and-rails"
---

Check out a follow-up on [Ruby Rogues](http://devchat.tv/ruby-rogues/205-rr-eight-years-of-ruby-and-rails-with-piotr-solnica)

Exactly 8 years ago I started working professionally as a rails developer. I’ve spent _a lot of time_ working for various clients, on various projects - from small green-field apps to 5+ year old rails monstrosities.

In addition to Rails development I got involved in OSS. Back in 2011 I joined [DataMapper](https://github.com/datamapper) core team, a couple years later I started working on [ROM](https://github.com/rom-rb/rom) project and effectively stopped working on DataMapper.

During this time I’ve learned a lot and I was lucky to be able to work with some of the brightest people in the ruby community. My experiences have had a significant impact on how I work, what I do, and _why_.

Today I decided to list 8 things that I learned that have either changed the way I work with Ruby or they’ve set a direction for the future. It’s not a deep technical dive but a higher level overview of my experience.

**TL;DR I haven’t switched to Clojure yet ;)**

## 1 - TDD

Test Driven Development is the single best thing I’ve learned during these 8 years.

TDD’s not dead. It’s pretty alive and kicking.

- Ruby has fantastic tools to help you write tests.
- I work faster and better when I practice TDD.

I do it even when I’m spiking. I do it even when I’m prototyping. It’s great.

The only problem I’ve had with TDD when in a Rails context is the notion of “rails is your application” - if that’s how you build your apps you will have trouble practicing TDD. If you care about decoupling your app’s code from Rails then you’ll find TDD to be a great companion.

## 2 - There’s a world outside of Rails

The Ruby community is amazing, there’s still a lot of great, positive energy and ethusiasm to build new libraries and frameworks. There is a world outside of our Rails bubble. If Ruby wants to evolve we simply have to get to a post-rails era where there are solid, viable alternatives to Rails.

## 3 - Immutability

A couple of years ago I started avoiding mutable state in my Ruby code. It was a struggle in the beginning but now it feels very natural. It makes me write code that’s less error-prone and simpler to debug.

Immutability is definitely not a first class feature in Ruby and feels at odds with Ruby’s OO paradigms. You **can** create objects that don’t change. It will save you a lot of time and make it easier to reason about your code.

## 4 - No rules, just guidelines

TDD has helped me to understand that I’m good when it’s easy for me to write tests for the functionality I want to implement; make those tests pass; be able to easily change and reason about the code I’ve written.

I found that applying OO rules rigorously to my ruby code has had some bad consequences. Knowing how/what to refactor and being able to do that with confidence, thanks to a solid test suite, is what counts the most.

And so I started treating “rules” and “laws” of programming as guidelines. I always have them in mind but I bend them or ignore them completely during my TDD cycles.

## 5 - Class interfaces are a smell

Defining public interfaces on classes is a common thing to do in the Ruby/Rails world. Class interfaces are a major problem - they cause accidental coupling and unnecessary complexity.

_Reminder: a Class is a globally accessible object that you can use without the need to inject it as a dependency._

I use class-level interfaces exlusively for building objects. It’s much easier to lower the coupling this way.

## 6 - Convenience has a big price

I’ve discovered there are countless of features in Rails and many other projects where the ease of use is a priority. We tend to measure quality of a framework or a library by the LoC that we need to write when using them, and it’s not that simple.

Rails has the convenient auto-loading feature where you don’t have to require files that define your dependencies. “Oh look, I don’t have to require files!” - true, but the result is increased coupling because you haven’t treated dependencies explicitly.

“Oh look, I can persist data with just one line of code!” - yes, and that convenience is based on a lot of simplifications and assumptions about the way you’re supposed to design and implement your application. When you realize you need something…less standard, you’ll be in trouble.

Being able to write code fast using convenient interfaces is important, but I feel sustainable maintainability is even more important. That’s why I write a little more code so that _I have control_. It doesn’t take much more time and it does save a lot of time later on.

## 7 - Mutation testing

Mutation testing is like TDD on steroids.

Mutation testing is one of the sharpest techniques I’ve learned and not an easy subject to write about. Luckily, we happen to have a powerful mutation testing library in Ruby called [mutant](https://github.com/mbj/mutant). While I don’t use mutation testing on a daily basis it is still part of my toolset and I find it to be very useful.

One of the best things about mutation testing is that it helps you to eliminate code that has needless side-effects. This can lead to less tests and less code.

In a language like Ruby with dynamic typing and a lot of mutable state using mutation testing can save a lot of your time. The only drawback is that it is a long road to understand how to use it efficiently.

## 8 - Ideas behind ORM are a fallacy

I’ve read criticism of the ORM idea in the past. I was skeptical that it could be done better. My latest discovery is that I agree with the criticism and it’s set a new direction for Ruby Object Mapper project and also for me personally.

These days any ORM that uses mutable objects and magic to persist data in a database makes me cringe.

I want simple data processing. I want immutable data. When I need to build a UI it should efficiently write changes back to the database when a client sends a request to do so. And that is not an ORM.

I create abstract concepts in my apps using entities, value objects, and “services” (whatever that means). It makes it easier to reason about my domain _but only when this modeling is a thin layer on top of basic data structures_.

Once you try to map business domain transactions to an actual database-specific transaction you’ll need a lot of extra, error-prone complexity.

I’m still exploring this subject and what you see in ROM is a result of my discoveries. So far I’ve been very happy when using it and I like the direction but we still need more time to evaluate certain ideas.

## To be continued

I still enjoy writing Ruby but I’m much more interested in a new wave of libraries and frameworks than in the evolution of Rails itself. Rails can be used effectively in many cases but there are various design aspects of this framework that bother me _so much_ that I can’t imagine using it anymore. Maybe it’s not Rails, maybe it’s just me.

Anyhow, it’s been amazing 8 years. I would like to thank all the amazing people who I’ve worked with so far and I’m looking forward to the bright future.

* * *

I would like to thank [Don Morrison](https://twitter.com/elskwid) for a review of this post.
