---
title: A quick​ recap and plans for the future
date: '2018-08-29'
categories:
- blog
tags:
- archives
- blog
- elixir
- oss
- personal
- ruby
slug: a-quick-recap-and-plans-for-the-future
aliases:
- "/2018/08/29/a-quick-recap-and-plans-for-the-future"
---

Hi, I'm back! I haven't written anything on this blog since November 2016, which is sad but it is what it is. I've got **so much** to tell you. A lot happened during this time, and I'll try to summarize it here and also talk a bit about my plans for the future.

### The Ruby Prize

### ![top_image06](/assets/images/top_image06.jpg)

Almost a year ago I was honored to go to Matsue, Japan, to attend the Ruby World 2017 conference, where I received the Ruby Prize from Matz himself. Getting the prize and visiting Japan was a fantastic experience for me, and I'm deeply grateful. I've been thinking a lot about the Ruby community since then, mostly reflecting on how we're evolving as programmers and trying to see how well my 8+ years of OSS contributions fit in this process. There are clear signs that a lot of Ruby developers are entirely on board with various ideas introduced by projects like [rom-rb](https://rom-rb.org) or [dry-rb](https://dry-rb.org). Watching growing adoption makes me very happy (dry-types has > 2.7M downloads on rubygems.org already!), but at the same time, I'm aware that there's much more work that we need to put into these projects if we want more people to use them.

https://twitter.com/\_solnic\_/status/925690395853336576

### Slowing down with Open Source

If you've been following my work on various Ruby libraries and frameworks, you probably know that I've put a ridiculous amount of effort into that. I met many people over the years who asked me how I managed to do it. The answer is simple - I just spent countless hours writing code, talking to people about writing code, reading about writing code and also removing what I wrote and writing it again, and again, and again. There's no magic here folks. On a positive note - I've learned way more through my open source contributions than through my professional work. On a less positive note, my personal life suffered too much, which is the reason why I tweeted this the other day:

https://twitter.com/\_solnic\_/status/953578620617920513

This tweet started a fascinating discussion, both public and behind the scenes. People were writing to me privately saying that they've had the same or similar experiences. I was pointed to various blog posts and talks, including a heart-breaking one like [this](http://jessenoller.com/blog/2015/9/27/a-lot-happens). As a result, I've spent a lot of time thinking about how to move on with my life.

I started slowing down already a year ago, roughly in May, and it's become clear to me that I need to change priorities (finally) so that individual projects can continue to grow without me spending so much time on it. There's this rather silly perception that OSS communities just automagically work because the code is available online, so people will start contributing. It **does not work like that.** I've had countless situations when somebody offered help with something specific, we talked about it, agreed on various details and then the person would "disappear". I don't blame them, and it's okay and understandable - people have their own lives, finding time for OSS contributions is very difficult. That's why lowering the barrier of entry is so crucial, as it increases the chance that somebody will manage to contribute, despite time constraints.

**I'm still a firm believer that any big OSS project must have a healthy community** to continue to grow and improve over time. That's why I want to shift my priorities from writing code to making sure that as many people as possible can write that code too and contribute as a result.

### Going forward with rom-rb & dry-rb

Given my reduced involvement, certain things slowed down. I published rom-rb 5.0 roadmap months ago, and it's still not released. I haven't found time to maintain dry-validation 0.x, and instead, I've started working on a rewrite for its 1.0.0 version. I've got a ton of ideas for dry-system, but **I know** I won't have time to make them a reality. With so many things I can't do, rather than ending up frustrated I'd like to try to make it easier for other people to take leadership and help with various bits of work.

In the short term, here are a few key things that I want to help with:

1. Wrap up rom-rb 5.0 quickly with only a handful of improvements, including first and foremost compatibility with latest dry-types, as it's blocking upgrade path for many people. We'll publish a more detailed plan for this release on the forum soon.
2. Finish dry-schema and figure out what to do with dry-validation. I'd love this to be a real community effort because a full-featured validation library turned out to be a more significant challenge than I thought it would be. I don't have any strong opinion about how we should proceed. I'll start a discussion thread on the forum soon, and we can discuss further.
3. Clean up issue trackers across all projects, establish better resources for contributors, improve documentation - my goal here is to make contributing to both rom-rb and dry-rb as simple as possible.
4. Work on tooling so that release process and updating documentation will be as painless as possible.

If there are other critical things that you think I should focus on - please do let me know, and we'll figure something out.

### Collaboration with the Hanami community

 

https://twitter.com/hanamirb/status/984055450139316225

You can read in Hanami's [1.2.0 announcement](http://hanamirb.org/blog/2018/04/11/announcing-hanami-120.html#what-39-s-next-) that we've decided to join forces and work together on Hanami 2.0. This effort involves people from rom-rb, dry-rb and hanami communities working closely together to achieve the same goals.

More details should be revealed by the end of the year. For me, this plays a major in creating a healthy community **and** a new ecosystem that will grow faster.

### Diving into Elixir

In April I joined [Citrusbyte](https://citrusbyte.com) where we have a bunch of Elixir enthusiasts. Recently we started considering Elixir for one of our new projects, which gave me a great excuse to look into the language and its ecosystem again.

It was rather simple to refresh my memory about the basics of the syntax, and a couple of hours later I was able to write a simple HTTP API client that I needed. Then I started reading about `GenServer`, and `Agent` and`Application` - I got so hooked you can't even imagine. There's so much in Elixir and OTP that I wanted to see in Ruby i.e. from Elixir's documentation:

> Applications are _loaded_, _started_, and _stopped_.

If you've ever used [dry-system](https://github.com/dry-rb/dry-system), this should ring a bell!

I couldn't help myself but think that this is the type of fresh energy that I needed badly for probably a very long time. My sense of responsibility kept me working on many Ruby projects for a long time, unfortunately being an underdog can be exhausting, and this is one of the reasons for my burnouts. Don't get me wrong - I know I've had a lot of support from many great people, but you have to agree that questioning status quo in a mature programming community can be rough. You can read a Q/A with me on [rubypigeon.com](https://www.rubypigeon.com/posts/questions-and-answers-with-piotr-solnica/) where I touch on that topic.

A while ago [I wrote about ditching Rails](https://solnic.codes/2016/05/22/my-time-with-rails-is-up/), I've never regretted it. In the article, I mentioned that I'm slowly moving into functional programming. This process continues. I want to stress though that **I'm not leaving the Ruby community**, I only need to learn something new as it keeps me going.

Writing some Elixir felt good, and I plan to continue doing so. I hope to start blogging about it too.🤞🏻

### New website

I've moved this very website from Middleman to Wordpress. If you're wondering why on Earth would I do that - there are a couple of simple reasons. First, I wanted https and a new domain, quickly. Secondly, I got tired of having to do everything manually in Middleman, and once I started thinking "maybe I should build my own static site generator" an alarm bell rang, and I thought "_wow stop right now!_". I used Wordpress in the past and moved away from it because my site got hacked few times, but this time I just went with the hosted solution at wordpress.com hoping that it'll be more secure. Last but not least - there are specific WP features that should allow me to keep writing something here on a regular basis.

OK, that would be it. I know this is a bit of a mishmash haha...as always, let me know if you have any questions or would like me to write more about specific topics that I mentioned here. Cheers ❤️
