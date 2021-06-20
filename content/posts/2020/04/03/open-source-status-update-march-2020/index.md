---
title: "Open Source Status Update - March 2020"
date: "2020-04-03"
categories:
  - "blog"
tags:
  - "dry-configurable"
  - "dry-rails"
  - "dry-schema"
  - "dry-validation"
  - "oss"
  - "rom-rb"
---

It's time for my second Open Source Update :) This one covers March 2020. As you can probably imagine, last few weeks were very challenging due to pandemic. I tried to push things forward regardless but I didn't manage to accomplish everything I planned.

![](/assets/images/Screenshot-2020-04-03-at-09.54.16.png)

### dry-schema & dry-validation 1.5.0

You can read the official announcement [right here](https://dry-rb.org/news/2020/03/11/dry-schema-and-dry-validation-1-5-0-released/). I'm very happy with both releases, especially that they brought many new features that a couple of years ago would be really hard to implement, but now it was relatively easy to achieve. The [schema composition](https://dry-rb.org/gems/dry-schema/1.5/advanced/composing-schemas/) feature is a good example of this, even though it's marked as experimental and not all details are fleshed out yet (like error message format for exlusive disjunctions), what already works is an advanced piece of functionality!

While working on both releases it became clearer what should be done in 2.0.0 upgrade. When it to comes to dry-schema, you should expect type specs becoming mandatory arguments. I also plan to _finally_ implement support for dynamic keys, where you'll be able to specify regexp-based key patterns along with their rules, ie `required(/\Aid_\d+\z/).value(:integer)`. This is a feature that many people have been waiting for 😄

### dry-rails 0.1.0

This took way more time than I anticipated. Originally I thought (and planned) that I'd release it in February. Unfortunately making it work with Rails 6 with Zeitwerk required more work and then I got distracted by other tasks from other projects and put it on hold. I finally got back to working on dry-rails in March. It turned out that supporting namespaced components that are defined in `app/*` dirs is against Rails' naming conventions, and it was simply not worth to fight it. I removed this feature, simplified internals and this allowed me to make `dry-rails` work with both Rails 5 and 6, including Zeitwerk support.

The first version of this gem was released earlier this week and I got a really positive feedback so far, which is fantastic! I don't have any specific plans for this gem when it comes to new features, except that I will add another built-in feature called `:operations` which will give you a base abstraction for defining command and query operation classes. This is something I've done in multiple projects (with slightly different approaches) and I think it worked extremely well as a concept. In `dry-rails` it'll provide a convention for encapsulating so called business logic using objects that essentially are based on `dry-monads` with a matcher interface.

I also want to use this as an opportunity to thank Xavier Noria for helping me understand how I should implement support for Rails 6!

### dry-configurable 0.11.4

After I rewrote `dry-configurable` earlier this year, people have been reporting various regressions, which was totally expected. The number of use cases for this library is close to infinite. This time it turned out I forgot that originially `Config#update` returned `self` and so I had to re-introduce this behavior in `0.11.4`.

I hoped this was the last one but then we had [another report](https://github.com/dry-rb/dry-configurable/issues/93) that after the rewrite you can no longer access config object within a `trap` block. As I said, people have a lot of use cases 😅

### rom 5.2.2

We had a small bug-fix release in early March. It turned out that I introduced a regression in `Changeset::Update` which resulted in `map` functions not being executed in the context of a changeset object. So, I fixed that and pushed a new release which also introduced a new short-cut method `Repository#transaction` which does exactly what you think it does.

I have to admit I've been quite sad that there was so little progress with rom-rb lately. The reason is quite simple - we've been all way too busy with dry-rb and since rom-rb works pretty damn well already, there was less pressure to work on it.

This doesn't change the fact that there are many things I'd like to do with it and I'm actually going back to working on rom-rb _this month_. The plan is to make it work really well with hanami-model 2.0.0. I want to add everything that's needed to achieve that. What it's going to be is yet to be determined. I suspect it'll boil down mostly to polishing existing features and adding various conveniences to make common things even simpler.

### April

Like I mentioned, I'm planning to spend most of my OSS time on rom-rb and hanami-model 2.0.0 this month. Apart from this, there are also a couple of new issues in dry-schema and dry-validation that I'm planning to address.

That's it for now - take care folks! ❤️
