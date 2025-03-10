---
title: WHOOPS! Thoughts on Rails, forking and leadership
date: '2021-05-01'
categories:
- blog
tags:
- archives
- community
- leadership
- rails
- ruby
slug: whoops-thoughts-on-rails-forking-and-leadership
aliases:
- "/2021/05/01/whoops-thoughts-on-rails-forking-and-leadership"
- "/whoops-thoughts-on-rails-forking-and-leadership"
---

I decided to let it all out. What a funny coincident because exactly 5 years ago I wrote that I’m leaving Rails for good. I thought I’m gonna leave Ruby too but that didn’t happen and I’m still a very happy Rubyist and because of this I’m really saddened to see what’s been going on the past few days; but HEY, it’s up to us to make something good out of it.

There are a couple of things I want to address and clarify through this post because:

- There are people who called for a Rails fork
- There are people who try to convince others (and themselves?) that Rails != DHH/Basecamp

Here’s the thing - **both groups of people are…kinda wrong** but unfortunately things aren’t so simple. Let me explain.

## Hey fork me, easy as 1-2-3

5 years ago I tweeted this:

https://twitter.com/\_solnic\_/status/734899942658088960?s=20

This is a great example of what you say when you're just angry and emotional but I actually thought that forking is a good idea back then. I no longer think that. I actually didn't even remember that I said that but yesterday I searched for "rails fork" on twitter because I was told that people are talking about it and...twitter decided to show my own tweet as the first result. Oh well.

Here's the thing. GitHub made forking effortless, but **everything that happens after you fork a gigantic project with 20 years of history is going to be really hard**.

The biggest problem with a fork is that it would cause **fragmentation in the ecosystem**. It would increase the cost of maintaining and growing thousands of projects pretty significantly. I bet a lot of people would still continue supporting the original framework, maybe it would even find new contributors. Then we’d have, let’s call it **“OnTrack”** framework, the new-but-not-really framework in Ruby, a fork of the famous Rails.

Great, what’s next? Which companies will switch to OnTrack? Will GitHub and Shopify just go ahead and do s/Rails/OnTrack/g in their gigantic codebases? What about thousands of OSS projects that are built as Rails plugins, railties, extensions, entire CMS systems, Forums etc.? Do you think people will just port everything to OnTrack? Some of them will, some of them won’t. Some people will start to fork various gems just to port them to OnTrack. Some people will make their gems work with both Rails and OnTrack. Regardless of what’s gonna happen, it’d be messy, very time consuming and very expensive.

**Really think about that**. I understand the emotions and **your instincts are correct** but unfortunately this is a complex issue and it won’t have a simple solution. _Fork is not a simple solution_.

It’s worth to mention that people calling for a Rails fork is a recurring theme in the Ruby community. **I do hope that this time it will result in some actual changes though.**

## Rails != DHH/Basecamp # false

I’ve seen lots of tweets saying that Rails is not Basecamp or that Rails is not DHH and so on. It really depends on what you mean exactly by this comparison, but here’s the thing:

**At the fundamental level "Ruby on Rails == DHH/Basecamp".**

Sure, it’s got thousands of contributors and a gigantic community behind it, but when you consider the very foundational aspects of the framework, this is all DHH. There are a couple of known facts and if it’s news to you, then good, you’ll learn something today:

1. DHH has the final say in every important decision regarding Rails UPDATE: The Core Team published an official explanation [right here](https://weblog.rubyonrails.org/2021/5/2/rails-governance/) saying that the decisions are always made by the team.
2. DHH openly admitted that he’s got the right to veto UPDATE: One of The Core Team members [explained](https://discuss.rubyonrails.org/t/effect-of-the-last-week-on-ruby-on-rails/77702/60) on the official discussion forum that DHH does not have the right to veto. I trust that this is true. Please notice that the information I provided here originally is based on what I was told by DHH. Admittedly, it was a few years ago, so things must've changed.
3. Basecamp is the main driver of Rails evolution.

I understand that maintaining a large OSS project requires strong leadership. The problem here is that **this is dictatorship** hidden behind 1-person “strong leadership”. We’ve seen its effects on the Rails itself many, many times. Another aspect is how Basecamp needs influence changes in Rails. There’s a lot of features in Rails that are there just because it was beneficial from the Basecamp’s point of view.

On one hand, it’s great that a lot of features have been added to Rails that a lot of other people can benefit from too. On the other hand, we ended up with stuff many people really didn’t want to see in their favorite framework. I know, you can’t please everybody and it’s OK.

**What’s not OK is having a process where one core team member can essentially tell you “STFU I like dis I use dis I merge dis BYE”.**

This can be hidden behind a wall of text, with many smart-sounding words, saying that your point of view has been considered but ultimately - yeah, well, STFU.

It’s natural to have disagreements in an OSS project and discuss things so that some consensus can be eventually reached; however, the process is unhealthy when there’s one person with the final say, and also, when there’s a single company that highly influences the direction of a given project.

**If that one person also happens to be the CTO of that one company**, then this is a big problem in my opinion, and so it’s been the problem with Rails. It was a great thing in the very early days of Rails because it drove the development in a very natural and effective way, but once the project became public and OSS, it has turned into a problem.

## So where do we go from here?

I understand that making tough decisions is hard and time-consuming, but we have a solution for that. It’s not perfect, but it works - it’s called voting. With a project so mature and large as Rails, it should be possible to organize a system for making decisions. This system doesn’t exist though and we can probably safely assume that it’s just not what DHH would want.

Here’s what I think what should happen to make Rails a better, healthier, more community-oriented project:

1. DHH steps down as “the one with the final say”
2. A new system is introduced that allows decision-making to happen in public
3. Basecamp stops being a huge influence on how Rails evolves

What this means is all the people who are now calling for a fork would have a great opportunity to step up and become the new leaders. Furthermore, the contributors and the people from the community in general would have a way to become a part of the decision-making process. Last but not least, it’s hard for me to imagine that things can become better without point #1 though. Whether DHH should remain as a core team member is another topic but that's something I really cannot comment on. I don't have the knowledge and I'm not even a Rails contributor, so I hope The Core Team will act accordingly (and no, I'm not suggesting he should be kicked out, in case you're trying to read between the lines).

I think I wrote about it in the past and openly admitted that THE reason why I haven't contributed to Rails is that I was afraid to interact with DHH. I haven't even reported a single issue because of this. The leaders set the tone and the tone that DHH sets is often discouraging. I know that we're "just humans" and me make mistakes. I've said lots of shit I regret and I've made a lot of mistakes as an OSS maintainer too. The thing is - **we gotta learn from the mistakes** and so I hope DHH can learn now.

The situation with Basecamp clearly triggered a lot of people in the community so this is a perfect moment to clear the air in the Rails ecosystem.

Let's talk. Let's **not** wait it all out. It'll be a failure if next week is business-as-usual.
