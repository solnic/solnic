---
title: Open Source Status Update
date: '2020-03-02'
categories:
- blog
tags:
- archives
- dry-rails
- dry-schema
- dry-transformer
- github
- github-actions
- middleman
- oss
slug: open-source-status-update
aliases:
- "/2020/03/02/open-source-status-update"
---

Inspired by Samuel Williams\` ["Open Source Progress Report"](https://www.codeotaku.com/journal/2020-01/open-source-progress-report/index) I decided to start doing the same thing and so this is the first Open Source Status Update from me. I hope to make this a habit and _who knows_ maybe I'll even start blogging on a regular basis again 🤞🏻

I'll summarize my work between September 2019 and February 2020. Overall these were extremely productive 5 months. Apart from the regular maintainance (PR reviews, handling releases, providing user support etc.) I focused mostly on improving documentation infrastructure for dry-rb and rom-rb projects, as well as spent _a lot of time_ on building tools to automate certain parts of the maintenance work.

This is organized per-topic rather than per-month because describing things chronologically would be too chaotic. It's easier to focus on a particular piece of work that I've done, even though it may have spanned multiple months (including some breaks).

OK let's go.

### middleman-docsite

In September 2019 I upgraded rom-rb.org website to the latest Middleman 5.0.0.rc1 (there's still no final release but it seems to work fine for us). When working on this upgrade I extracted a reusable piece that I called [middleman-docsite](https://github.com/solnic/middleman-docsite). This project provides various convenient APIs that are used by both rom-rb.org and dry-rb.org website projects. Its primarly feature though is support for _importing documentation pages from external repositories_. It does it by cloning and managing external repositories and it was literally the simplest thing that could possibly work. Initially I planned to use Antora but after closer evaluation it turned out it will be quicker and simpler to build a custom solution and reuse it in rom-rb.org and dry-rb.org.

Overall it took me few months to wrap it all up, mostly because I was on a sick leave in late October and throughout the whole November. Eventually I finished upgrading dry-rb.org on October 4th and rom-rb.org, which was much more challenging, was upgraded on January 25th. I'm very happy with the results - we have documentation for individual gems properly versioned and living in individual repositories. This makes updating documentation much simpler and more natural, ie whenever you open a PR with a new feature, you can (and should) add docs for it too. Another nice improvement is that we have documentation generated from master branches too, so it's easy to see what's coming next.

### dry-transformer

In December I finished porting [transproc](https://github.com/solnic/transproc) to [dry-transformer](https://github.com/dry-rb/dry-transformer). I used this as an opportunity to clean it up a bit too. This project is almost identical as Transproc and it will be used in ROM 6.0.0 _instead of_ Transproc. You should expect various internal improvements, bug fixes and general polishing before dry-transformer hits 1.0.0. There's no strict roadmap yet so if you've been using Transproc and you have some ideas on how things could be improvements - now is a perfect time to tell me.

### GitHub Actions and Automation

If you [follow me](https://twitter.com/solnic29a) on Twitter you probably know how excited I am about GitHub Actions. I started adopting them in dry-rb and then rom-rb organizations on GitHub as soon as we got access. I started working on adding workflows to dry-rb in early October and since then things progressed quickly!

Right now both dry-rb and rom-rb use GitHub Actions to automate the following things:

1. Continues Integration - the most common thing as you may expect. We moved from TravisCI which served us well for many years to GitHub Actions. There's a central `ci.yml` workflow configuration that's shared between all the repositories with the ability to override _certain parts_. It's got a couple of limitations now (ie it's not possible to define a custom list of rubies for a project without overriding the whole configuration) but everything can be eventually improved. Switching to GitHub Actions to run our tests have been a great success - our builds are _multiple times faster_ than before which is crucial if you take into consideration the limited time people have to work on OSS.
2. Common files - semi-static common files like `LICENSE`, `CONTRIBUTING` or `CODE_OF_CONDUCT` but also shared test-related files or GitHub issue/PR templates - all of that is now centralized, distributed and kept up-to-date across 40+ repositories thanks to GitHub Actions. This is a major time-safer!
3. Semi-common files - there are other types of files that have the same structure but different content. For example a gemspec or a Gemfile - these are also centralized via templates that are rendered per repositories and kept up-to-date automatically through a GA workflow
4. CHANGELOGs - these are now rendered using a template + a data file called `changelog.yml`. As a bonus I added a way to update \`CHANGELOG.md\` via commit messages. When you merge a PR and provide a special `[changelog]` section in your commit message, then the changelog will be updated with your entry.
5. Pushing to RubyGems.org - that's right. We now have a workflow that will push a new version of a gem automatically whenever a signed tag is created by a user with proper permissions. In the near future creating a release on GitHub will trigger the release process too. This means we'll be able to push a release via GitHub exslusively without the need to open a terminal.

It was **a lot of work** and luckily [Nikita](https://github.com/flash-gordon) started helping me out and together we managed to build all those workflows. It was worth the effort and I'm very happy with the result. You can check out our [dry-bot](https://github.com/dry-bot) or [rom-bot](https://github.com/rom-bot) accounts to see how busy they are 😀

### dry-rails and dry-configurable rewrite

In February I started a new project called [dry-rails](https://github.com/dry-rb/dry-rails) which is the official dry-rb railtie for Rails. Its core is based on dry-system-rails and it builds on top of that core by providing built-in components like `ApplicationContract` or controller helpers for defining type-safe param schemas. More features will include monadic operations which will be a great place to put your business logic in and proper support for test environment. This project has not been released yet as I kinda got stuck with Rails 6 + Zeitwerk support but I will figure it out and release the first version of dry-rails in March.

While working on dry-rails I hit a couple of limitations in dry-configurable which is used under the hood. Trying to remove these limitations from the existing codebase turned out to be too hard so I decided to [rewrite](https://github.com/dry-rb/dry-configurable/pull/78) the library from scratch. It took me ~30 hours to trully finish this rewrite even though initially I thought it will go much faster (I know, I know). Unfortunatelly this library handles all the things that are damn hard to deal with - global state, mutability and inheritance (what can _possibly_ go wrong 😂). I think it was worth the effort though as it's going to be simpler now to polish the API, make some smaller adjustments and finally release 1.0.0 - reminder that dry-configurable is **the first** dry-rb library!

### Working on dry-schema 1.5.0

I'm not sure how it happened but I found myself working on dry-schema 1.5.0. I guess one thing led to another and I just thought it's a good moment to have a bigger release now.

There are many pretty substantial new features and improvements coming up in this release including this:

https://twitter.com/solnic/status/1233312534716977152

There are [5 outstanding issues](https://github.com/dry-rb/dry-schema/milestone/17) in the 1.5.0 milestone at the moment, I'm planning to address them all and we'll have a nice release ready.

### Summary

As you can see, I've been busy, but it was the good type of busy. If you have any suggestions about the format and/or content in this series of articles please do let me know!
