---
title: "Open Source Status Update – April - June 2020"
date: "2020-07-09"
categories: 
  - "blog"
tags: 
  - "dry-rails"
  - "dry-rb"
  - "dry-schema"
  - "dry-validation"
  - "github-sponsors"
  - "hanami"
  - "oss"
  - "rom-rb"
---

It's finally time for another Open Source Status Update! This one's different as it covers last three months. Due to pandemic situation and having my kids at home, including online schooling, it was really difficult to do any OSS hacking. We've got some things done regardless in March and April thanks to support from our contributors, so I also would like to use this as an opportunity to thank you all for your help!

OK let's see what happened during the last three months.

## April

We had [a new dry-monitor release](https://github.com/dry-rb/dry-monitor/releases/tag/v0.3.2) that fixed compatibility with `Rack::Builder#use` and also brought a couple of performance improvements. Thanks to Anton and Luca from the Hanami team for helping with this release! If you've never heard about dry-monitor, go and [check it out](https://github.com/dry-rb/dry-monitor) as it's a set of useful extensions for monitoring a rack-based web apps. It is used in dry-web apps and it'll be a great fit in Hanami 2.0 apps too. Personally, I have plans to finish and improve it later this year so that we could finally release its 1.0.0 version.

In rom-rb land I finally published [initial documentation](https://rom-rb.org/learn/factory/0.10/) for rom-factory which was contributed by [k0va1](https://github.com/k0va1) - thank you!

## May

In May we had [a new dry-schema bug fix release](https://github.com/dry-rb/dry-schema/releases/tag/v1.5.1) which, amongst other things, addressed an issue where key validation would crash with various array-type validations. The [key validation feature](https://dry-rb.org/gems/dry-schema/1.5/advanced/unexpected-keys/) is quite new and given the enormous amount of potential use cases I'm not surprised we're finding bugs there. I suspect its implementation will settle in dry-schema 2.0.0 though.

It looks like people started using dry-rails as we had a bunch of fixes and improvements done in May. I fixed [a small problem](https://github.com/dry-rb/dry-rails/pull/30) with `:env` plugin that was not enabled by default, which caused crashes in various use cases. Then we had a couple of nice pull requests where [gotar fixed issues](https://github.com/dry-rb/dry-rails/pull/24) with `safe_params` feature and [diegotoral added](https://github.com/dry-rb/dry-rails/pull/29) support for configuring the import constant name. The latter is going to be really handy in case you have `Import` already in your app. With these improvements and fixes I wanted to release dry-rails 0.2.0 but I had some issues with the build stability, which distracted me, and then I couldn't find time to do the actual release. I will do it in July though 😄

## June

Last month we had [another dry-schema](https://github.com/dry-rb/dry-schema/releases/tag/v1.5.2) release and it was based 100% on contributions. This time [adamransom fixed](https://github.com/adamransom) an issue with key validation that didn't cause result failure if there were only key validation errors. This was a silly oversight on my behalf and it was great to see that it was spotted _and_ fixed in a PR ❤ The other change made by [tadeusz-niemiec](https://github.com/dry-rb/dry-schema/pull/292) was related to the `full` option support and it addressed [a really old issue](https://github.com/dry-rb/dry-schema/issues/161) which was originally reported in dry-validation repository in pre-1.0 era. Now the `full` option no longer adds spaces between words in languages that don't use spaces, like Japanese.

We had [a new dry-validation](https://github.com/dry-rb/dry-validation/releases/tag/v1.5.1) release too and this one was also fully done by contributors! There were a couple of fixes from [sirfilip](https://github.com/sirfilip) who addressed a problem with the `full` option when used with rules and also fixed `locale` option when used with `:hints` extension. This extension should be improved in 2.0.0 because its implementation is very complicated and _I think_ I have a good idea how to improve it 🤓 This release also includes a small fix from [schokomarie](https://github.com/schokomarie) which removed an unnecessary require statement. This was another oversight on my behalf when I worked on extracting dry-schema from dry-validation. When you move things around it's easy to miss such cases. This made me think that we should improve our test suite so that we run it in more scenarios when it comes to optional dependencies. This is what [I managed to do in dry-validation](https://github.com/dry-rb/dry-validation/blob/master/Rakefile#L15-L45) and the same approach should work in dry-schema.

## The work on rom 6.0.0 has started

Yes! In June I finally started working on rom 6.0.0. This release will be mostly focused around making sure that rom and its adapters can be easily used as the backend for hanami-model 2.0.0. I started with [a huge PR](https://github.com/rom-rb/rom/pull/601) that merged `core`, `repository` and `changeset` into `rom` gem. This means starting with 6.0.0 rom suite will be just one gem. I'll explain the reasoning behind this decision in a separate post or a screencast, as there's a lot to talk about here.

In June this happened as well:

https://twitter.com/\_solnic\_/status/1275738259432366080?s=20

This is something I'm personally very excited about because I'm looking forward to leveraging Truffle's concurrency in not-so-distant future!

This time I haven't published a roadmap on our forum, and instead I simply reported a bunch of issues and assigned other existing issues to [the 6.0 milestone](https://github.com/rom-rb/rom/milestone/11). Please treat this as the roadmap, but I should mention that things _may change_ as we move forward with the work.

One of the biggest priorities for 6.0.0 is to eliminate any rough edges and improve UX - that's why it would be great if you could tell me about your experience with rom, especially if you found it too hard to use for some reason. Feel free to leave a comment under this post or [ping me on twitter](https://twitter.com/solnic29a) or start a thread on [our discussion forum](https://discourse.rom-rb.org/) or [chat](https://rom-rb.zulipchat.com/).

## YouTube Channel

In June I _finally_ launched my YouTube Channel so go [right here](https://www.youtube.com/channel/UCeRgtx8eE4WXqGAeeDQyGYQ) and subscribe - it'll mean a lot to me! In the first screencast I'm exploring Tim's Hanami 2.0 application template, check it out here:

https://www.youtube.com/watch?v=FH\_EIlN89cQ

I'll most likely record pt. II next week so stay tuned 😄 A lot of people have been asking me for dry-rb screencasts, so I've made this my priority and I'll be publishing them later this month.

Setting this up and recording the first video was actually (surprisingly?) a lot of work and I'm so, so happy that I've managed to do it eventually. So far I've been receiving a really positive feedback from y'all so thank you _so much_ ❤ This motivates me to do more!

## GitHub Sponsors

Since April, [Benjamin Klotz](https://github.com/tak1n), [Peter](https://github.com/gadimbaylisahil) [](https://github.com/peterberkenbosch) [Berkenbosch](https://github.com/gadimbaylisahil), [Ryan Bigg](https://github.com/radar), [Oleksii Leonov](https://github.com/aleksejleonov) and [Sahil Gadimbayli](https://github.com/gadimbaylisahil) have become my new GitHub Sponsors! **Thank you!** ❤

This wraps up my third OSS update. You should expect another one in a month from now! Feel free to leave a comment if you have any questions.

I hope y'all are safe and healthy!
