---
title: The State of Ruby ORM
date: '2011-11-29'
categories:
- blog
tags:
- archives
- activerecord
- blog
- datamapper
- orm
- patterns
- ruby
- sequel
slug: the-state-of-ruby-orm
aliases:
- "/2011/11/29/the-state-of-ruby-orm"
- "/the-state-of-ruby-orm"
---

**UPDATE**: DataMapper 2 was renamed to Ruby Object Mapper (ROM). For more info check out [rom-rb.org](http://rom-rb.org/)

* * *

We have a lot of different Object-Relational Mapper implementations in Ruby (and a ton and a half of Mongo mappers ;)) and it’s probably a good thing. It seems like the only ORM that really matters right now is ActiveRecord although in “the background” we still have DataMapper and Sequel with growing communities. So I’m wondering…what’s the state of these ORMs? This post is my brain-dump on the subject with a potential to start a disccusion about the future of Ruby ORMs. This is a huge subject but I’ll keep it short.

## (beloved) ActiveRecord

I’ve been a rails developer for almost 5 years now and I remember my initial excitement about ActiveRecord just like if it happened yesterday. I remember how blown away I was when I saw ‘an empty’ class in app/models with a ton of functionality added dynamically. I remember how happy I was when I started setting up associations for the first time and seeing that I can easily use them and everything just works OOTB. I remember how awesome it was to use built-in validations - a few lines of simple ruby code and my model is “secured” and invalid data won’t be persisted. Just like that! I also remember what a great feeling it was to use migrations for the first time, oh man there was even a generator which creates files for me, wonderful! Yeah, that was really great and I loved it.

Years were passing and my excitement was slowly disappearing and now it’s almost completely gone. Why? What happened? First of all I’m disappointed with AR3. I thought transition to ARel and the general Rail3 refactor will lead to a better codebase and nicer API. What we have now is like a hybrid of AR2 and something that was promised as AR3 which was not finished in 100%. The general lack of consistency in the API worries me. Too bad because making a major bump in the version number was a great opportunity to clean things up for good. Now we have to wait for 4.0. I’m also still facing various “WTF moments” when I see things like that:

```generic
User.where(:active => true).kind_of?(Enumerable)
 => false

```

Yeah I know that’s just rude to point things like that, right? On the other hand is this what you would expect from a library which has a version number > 3.0? I’d expect some level of maturity but what I see now is still a bit of a mess. It’s definitely getting better so probably, with this level of support that AR has now, version ~5.0 will be truly great and mature. I’m really looking forward to that.

Through all those years ActiveRecord got a lot of great features though. Lazy queries, attribute serializers, prepared statements just to name a few. Extracting ActiveModel was also a huge step into the right direction and I’m very happy with it. It’s all great and the improvement is clearly visible.

On the other hand there are still cases where ActiveRecord fails. For instance it still has problems with proper handling of object graph. Which isn’t a great surprise because _it’s a tough problem to solve_ and none of the 3 ORMs has solved it yet.

## (bold) [DataMapper](http://datamapper.org)

With ActiveRecord you get things done, that’s true. Just read the recent post from Xavier Shay [“DataMapper Retrospective”](http://rhnh.net/2011/11/29/datamapper-retrospective) where he writes why he likes DataMapper and despite that why he chooses ActiveRecord. He writes “This is my responsible choice at the moment” - I would expect that in many, many cases people pragmaticaly and wisely choose ActiveRecord because the support from community is important and ActiveRecord does have the best support at the moment. When you get yourself into trouble with AR you will likely find help relatively quickly.

After reading Xavier’s post I feel obliged to comment on it. First of all I agree with him and his decisions. DataMapper is trying to solve bigger problems than AR and Sequel. It’s obviously much harder to support any kind of a storage system and it requires a lot of work. It definitely requires more than a couple of years of development and one stable version. DataMapper 1.x series was a great milestone as the API became stable and it’s truly great, just look at this:

```generic
# DataMapper
User.all.posts.comment.all(:created_at.lt => DateTime.now)

# ActiveRecord
User.includes(:posts => :comment).where(:comments => { :created_at.lt => DateTime.now  })

```

DataMapper introduced a lot of fantastic solutions and just recently ActiveRecord started catching up. It doesn’t change the fact that DataMapper 1.x is much harder to use when you have to resort to raw SQL. That’s why I perfectly understand why Xavier prefers AR and Sequel - both ORMs are built specifically to handle RDBMS and they do it in a decent way.

This post would get too big if I started to write more about DataMapper that’s why I’m stopping now. I will write about what’s happening in the DataMapper camp in a separate post where I will give you an overview of our plans for the near future - expect a lot of goodness to say the least.

To quickly sum up - DataMapper is not there either but getting to the point where we are now was a great experience that’s given us knowledge about how certain problems should be solved. More about this in a separate post…

## (impressive) [Sequel](http://sequel.rubyforge.org)

I’ve never been a sequel user. I only tried it out a couple of times in the past and it was really nice. The codebase looks much cleaner than in case of ActiveRecord and the feature set is truly impressive. I’m also absolutely amazed that this project has 0 issues on github - HUGE congratulations to Jeremy Evans. He’s doing a fantastic work and I’m really impressed so you should be.

I remember that Sequel introduced various advanced features before AR did - like lazy data sets (aka lazy execution of queries). You probably quickly forgot or you aren’t aware of the fact that AR was _the last_ Ruby ORM that introduced this feature.

I’ve heard from many people that are familiar with Sequel that it’s simply better than ActiveRecord in every aspect. I would not be surprised if this turns out to be true.

I would love to hear more about your experiences with Sequel so please feel free to leave comments!

## The State of ORMs?

Right. So where are we now with our favorite ORMs? In my opinion whether it’s ActiveRecord, DataMapper or Sequel - we’re still “not there yet”. I’ve been looking at other languages lately and it’s pretty clear that in Java, Python and PHP most popular ORMs implement the Data Mapper pattern. I’m not saying that this pattern is better. There’s been an open debate about AR vs DM patterns since for ever and there’s no ultimate answer. The fact is, though, that in most of the cases DM _is the preffered one_. And ORMs in other languages reflect that. Java with its powerful Hibernate, Python with its SQLAlchemy and PHP with its Doctrine. All those projects are mature, have solid codebases and solve hard problems using well known design patterns.

I really like what I see in those ORMs. They all implement [Unit Of Work](http://martinfowler.com/eaaCatalog/unitOfWork.html), [Identity Map](http://martinfowler.com/eaaCatalog/identityMap.html) and a lot of other patterns that I didn’t have time to identify. It’s all there. Damn hard problems solved in a clean way with OOP approach and design patterns that were known for many years. When you open up sources of SQLAlchemy or Doctrine you are able to quickly navigate through those projects - classes are well organized and it’s easy to figure things out.

I understand why people like “the less is more” and “convention over configuration” but personally I would love to see more explicitness in Ruby ORMs. Metaprogramming is a dangerous weapon and we shouldn’t forget about this. You probably think “STFU and switch to Java” now. Well, that’s not gonna happen :)

All of this doesn’t change the fact that I believe _we can still do better_. By looking at other languages we can find a lot of inspirations but many things can be done in a much better way in Ruby.

I would love to get some feedback from you. Are you happy with your ORM of choice?
