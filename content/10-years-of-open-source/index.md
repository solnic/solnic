---
title: 10 Years of Open Source
date: 2021-06-04 16:38:41.000000000 +02:00
categories:
- blog
tags:
- archives
- programming
- oss
- ruby
- thoughts
- community
- github
slug: 10-years-of-open-source
aliases:
- "/2021/06/04/10-years-of-open-source"
---

On June 4th, 2011 I released the first version of Virtus, a ruby gem that I extracted from the DataMapper project.

I remember how I felt about Open Source back then, and I have to tell you that my perspective has changed **a lot**.

10 years, a freaking decade, is a lot of time...I've gone through a lot of ups-and-downs during that time, as my open-source contributions sky-rocketed, and that changing perspective is something I continuously think about. I don't know how many projects I contributed to, how many libraries I've written, I honestly do not know.

This 10-year anniversary made me super emotional and I have a lot of thoughts about Open Source that I’d like to share.

This will be bitter-sweet and probably too long. Please keep in mind that this is based on my own experience and I'll do my best not to generalize too much.

## How my perspective changed

I remember that in my mid 20s, when I was already working as a software developer, I had this concept in my head that Open Source is this amazing thing that everybody is doing. Maybe it sounds ridiculous but it is exactly how I used to see it. I'm a heavy-thinker and a natural problem-solver and on top of that I'm super impatient.

This was a perfect mix to become an Open Source contributor because whenever something didn't work for me I was either working on a patch 10 seconds later, or I was already half-way through prototyping my own solution.

This is exactly how I ended up contributing to DataMapper, then joining the core team, then releasing Virtus, then working on DataMapper 2.0, then turning it into [rom-rb](https://rom-rb.org), then joining [dry-rb](https://dry-rb.org) and building 1.25 library / month on average for about 2 years or so to eventually join [Hanami](https://hanamirb.org) team...and, yeah, it's been kinda nuts now when I look back.

**For the most part I kept thinking "this is what everybody does" until I realized it's absolutely not the case.**

The first thing that hit me was the amount of work that's needed "just" to maintain a library. Even when you have a library that is used by, let's say, 27 people (which is a relatively low number) this can easily turn into 10+ hours of work per month, every month. If you have more than one library, and the total number of people using your stuff is now counted in hundreds or even thousands, this can easily get out of hand. There will obviously be downtime in various projects, especially the more mature ones -- but on average once you maintain something, it becomes super hard to find time to do the work that you *actually want to do*.

This is when things become difficult.

## What's the deal here?

You're obviously responsible for managing your time and what you do and we could easily just say "well, nobody forces you to work on OSS" and end the discussion...but is it that simple?

People think that Open Source is just this one big, global family. Thousands of people working on all these amazing libraries, frameworks and tools.There's this idealistic view of Open Source that was absolutely, clearly visible to me. I *feel* like it's changing a bit these days but it's still there for sure.

**I keep meeting people who are almost apologetically telling me that they wish they had contributed more.**

My question is: what's the deal here? What makes us think that we're obliged to do this?

The way I see it is that we've created this impression ourselves as an industry. We kept telling ourselves that we need to build Open Source Software because it's the future of software (and it is!). We also kept convincing ourselves that this is how you can become a better developer (and you can!) and so some folks just double down on working harder.

Then you have companies and their expectations. It used to be - and probably still is - very common to see job offers where "contributing to OSS" was mentioned as either a "nice to have" or even a requirement. I think it's a bad practice now, except for cases where the job really does involve contributing to OSS.

I believe companies giving you extra props for OSS work contributed heavily to this notion of OSS as something that we're supposed to do.

The question, however, remains unanswered. What’s the deal here? I feel like we can all try to come up with our own answers that will work for us at an individual level. It's very hard to come up with a universal answer though.

When you have a product and a client using your product who's paying you to do your work, then the deal is simple - you work on what they need, and they pay you for it. But When it comes to Open Source this is extremely complicated and vague. What's the product? Who's the client? Can we even treat an open-source project like that? Or maybe the deal is that there is no deal and that's the beauty of it?

## Let's be real

If you're a maintainer then this will probably ring some bells. If you're not and you're using OSS then this could be useful.

Let's be real - we're not one big, global, family. Most of the work is done by a tiny little fraction of the global developer population. We like to think that we're all in this together but we're not.

You can come up with great looking stats, showing that thousands of people are contributing to OSS projects -- but in reality the actual bulk of work, the countless hours spent on building core functionality, testing, fixing bugs, making performance improvements, supporting users, writing docs, responding to issues, dealing with pull requests and so on are done by maintainers.

Let me also make it very clear: *all contributions count, they are important and highly appreciated*.

But my point is to underscore the fact that when 1000 people did a little bit of work each, then you get significant results in total, but please realize that *the time* that each person spent on their contributions cannot compare to the time that maintainers spend doing their work.

To illustrate the type of situations maintainers have to deal with on a regular basis, here are some real world scenarios:

- You get a bug report from somebody. You spend 3 hours debugging and coming up with a patch. You ask the user to test it out. The user never gets back to you.
- You get a feature request. You spend hours discussing it. You're going through source code figuring out how it could be implemented. You end up with a nice PoC. You ask the user if it would work well. The user never gets back to you.
- You get a Pull Request. You review it and it's looking good but you leave some comments because a couple of small things must be addressed. The user never gets back to you.
- You get a Pull Request out of the blue with an angry user trying to point out your mistakes. You do your best to be polite but the user keeps attacking you. You spend hours in total just to discuss it. You reach some level of consensus and then guess what, the user never gets back to you.
- There's this issue that somebody reported over a year ago and you want to address it eventually but you can't find time/energy/motivation/etc. to do it. It is marked as "help wanted" but people keep pinging you with comments like "any progress on this?". The uncomfortable sense of guilt starts to creep in even though it's not even your job.

...and man I could go on.

Here's something to think about: **nobody has the time to work on Open Source**. Nobody. There is no time, yet we somehow do it. Many of these situations are caused by the fact that a user hasn’t enough time. In other cases it's the maintainer who hasn’t enough time. We struggle to push things forward and it's often *extremely unproductive*.

## Sponsored Open Source Work
It's very tempting to say that now we have all these platforms where Open Source maintainers can be financially supported therefore the problem is solved. Unfortunately, things are not that simple.

First and foremost I believe that sponsored Open Source work is still a situation where it's hard to say what the deal is. Not to mention that you can only be successful at getting sponsorship if your project *is popular enough*.

I think in OSS in general there's this long-tail of OSS maintainers doing very important work on lower-level libraries, but it's the type of work that’s not as visible as it would be in a more visible, top-level project... Not to mention that you need a project in the first place and just that is already a big time investment. Assuming that you do make it, and you do now have an OSS project that is used by a significant number of people you STILL need to invest a significant amount of time in order to build your presence.

This is important -- nobody will discover you just because you published a project on GitHub. This is harsh reality but I think it's true.

**You *cannot assume* that every OSS maintainer is willing to do the type of work that is needed to become sponsored.**

As much as I appreciate GitHub Sponsors, I still think there should be a more aggressive shift towards sponsorship *from businesses*, rather than individuals. Many people have shared with me [an article](https://calebporzio.com/i-just-hit-dollar-100000yr-on-github-sponsors-heres-how-i-did-it) from an Open Source developer who quit his day job and is now making more than before, solely through GitHub Sponsorship. When I read this article, my first thought was "wow this is so awesome" but then I quickly realized what kind of an effort this actually was.

This developer is clearly good at his game. He's a natural communicator and marketer, you can tell. **Now think about how many people, realistically speaking, are able to do what he did?** I believe not that many. Consider people whose English is not their first language. Even this common “limitation” makes getting sponsors challenging -- because you need a convincing, well written intro on your landing page, and a native English speaker will most likely do a better job.

**We need companies sponsoring Open Source work**

I'm very grateful for my individual supporters, but I am openly saying that I don't believe that this is how it should work. I hope people who support me really benefit from my work but at the same time it's kind of crazy that my libraries are used by Netflix or Apple yet they are not my sponsors. *This* is what I would love to see change.

**The number of companies sponsoring OSS work should be greater than the number of individuals supporting OSS work**. I don't know what the numbers are now and it would be really interesting to see some stats.

I know there are people sponsored by many companies, and I know that some companies hire OSS developers as full-time employees. This is fantastic, and I hope it's going to become the norm at some point. Right now it looks like we're going through some kind of a transition phase and I'm actually really optimistic.

## Thank You ❤️

On a very personal level - I want to thank everybody from the Ruby community and all the people who helped me grow, who inspired me and who supported me through difficult times. Thank you for your trust and for putting up with me for so long 😆

I know this post is bitter-sweet, but overall, what I actually want to say is that I'm very grateful. I've learned so much and I'm sure I will learn even more.

---

*Thanks to Tom Russell for reviewing a draft of this post!*
