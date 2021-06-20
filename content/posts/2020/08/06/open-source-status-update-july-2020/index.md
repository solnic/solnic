---
title: "Open Source Status Update – July 2020"
date: "2020-08-06"
categories: 
  - "blog"
tags: 
  - "dry-rails"
  - "dry-validation"
  - "hanami"
  - "oss"
---

In July I went on holidays and had quite a busy month at my day job but nevertheless I've managed to push things forward. Here's a summary of what happened!

## New dry-validation releases

We've had two bug-fix releases of dry-validation. Just like in case of a couple of previous releases, there were a bunch of really nice PRs from contributors which is lovely 😄

In 1.5.3 [I've fixed](https://github.com/dry-rb/dry-validation/pull/654) a new bug that was discovered recently where using `key?` helper inside a rule would crash in case of a deeply nested data structure that has nested arrays. In general, even after few years of development we keep seeing bugs related to complex data structures. I always need to remind myself that the number of use cases is gigantic and it's going to take a while until we see fewer (or even no) bug reports similar to the one I mentioned.

It's worth to mention that dry-validation and dry-schema have been created to _make it trivial to validate complex data structures_. For me, this was one of the biggest motivations back in 2015. I think we've come a long, long way since then and existing functionality, despite seeing some bugs every now and then, is already extremely useful and valuable.

The second bug-fix release was [1.5.4](https://github.com/dry-rb/dry-validation/pull/660) where I've [fixed another bug](https://github.com/dry-rb/dry-validation/pull/660) related to checking for "base errors", which are errors not associated with a specific key. This one was a major 🤦🏻‍♂️ moment for me, because it turned out a related spec had a syntax problem where **a spec example was accidentally nested inside a let statement**. This made the spec pass with no warnings or crashes. I guess it's something that RSpec could catch and trigger a warning.

## dry-rails 0.2.0

I finally managed to resolve problems with some flaky specs! We're targeting both Rails ~5.2 and ~6.0 and because of this, the spec setup is a bit complex. Running specs in isolation is tricky due to the global state that is being changed. Setting/resetting things is essential and sometimes a specific order of execution may leave the suite runtime in an unexpected state. This is exactly what happened in this case where [I had to ensure](https://github.com/dry-rb/dry-rails/commit/1cf16fc5c6a2fdc6839a6da65a8d0448d44d1e68) that one of the configuration settings gets reset to the original state.

Apart from fixing spec suite stability, this release brought a nice new feature! Thanks to [diegotoral](https://github.com/diegotoral) you can now _configure import constant name,_ which is really cool:

```ruby
# config/initializers/system.rb
Dry::Rails.container do
  config.auto_inject_constant = "Inject"
end

# then in your component classes
class DoSomething
  include Inject[:logger]
end
```

This release also includes a couple of bug fixes from [jandudulski](https://github.com/jandudulski) and [gotar](https://github.com/gotar) - thank you! ❤

## Hanami 2.0

I've been making myself more involved in the process through my screencasts recently. I wanted to record part 2 of my "Exploring Hanami 2.0 application template" mini-series and the original plan was to show writing specs for the controller/view layer. My initial attempt allowed me to discover a couple of issues with session and flash handling, so I postponed this episode. It was really awesome to experience how controllers and views work though. You can check out [Tim's OSS update](https://openmonkey.com/writing/2020/08/03/open-source-status-update-july-2020/) where he writes about the recent controller/view work.

Here's the episode that I eventually recorded, where I talk about component loading through dry-system and the test setup in general:

https://www.youtube.com/watch?v=H1eKIO39ob8

## Current month

OK that's what I have as part of the July update! In August, I'll be working more on rom 6.0.0. There's an ongoing discussion within the Hanami team about rom + hanami-model and we should have some exciting news for you soon, so stay tuned 😄

Stay safe and healthy my friends!
