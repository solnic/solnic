---
title: My time with Rails is up
date: '2016-05-22'
categories:
- blog
tags:
- archives
- blog
- rails
- rant
- ruby
slug: my-time-with-rails-is-up
aliases:
- "/2016/05/22/my-time-with-rails-is-up"
---

> Please also read my follow-up about [abstractions and the role of a framework](https://solnic.codes/2016/05/30/abstractions-and-the-role-of-a-framework/)

Last year I made a decision that I won’t be using Rails anymore, nor I will support Rails in gems that I maintain. Furthermore, I will do my best to never have to work with Rails again at work.

Since I’m involved with many Ruby projects and people have been asking me many times why I don’t like Rails, what kind of problems I have with it and so on, I decided to write this long post to summarize and explain everything.

This is semi-technical, semi-personal and unfortunately semi-rant. I’m not writing this to bring attention, get visitors or whatever, I have no interest in that at all. I’m writing this because I want to end my discussions about Rails and have a place to refer people to whenever I hear the same kind of questions.

I would also like to tell you a couple of stories that “younger rails devs” have probably never heard of, and highlight some issues that are important enough to at least think about them.

## The Good Part

I’m not going to pretend that everything about Rails is bad, wrong, evil or damaging. That would be not fair, and plain stupid. There’s a lot good stuff that you can say about Rails. I’m going to mention a couple of (obvious?) things for a good balance.

So, Rails has made Ruby popular. It’s a fact. I’ve become a Ruby developer, which in turn changed my career and gave me a lot of amazing opportunities, _thanks to Rails_. Many rubyists these days have gone down the same path. We are all here thanks to Rails. In many cases, Rails actually made a tremendous impact on people’s lives, making them _much better_. Literally. People got better jobs, better opportunities, and better money. This was a game-changer for many of us.

Over the years Rails & DHH have inspired many people, including people from other communities, to re-think what they’re doing. For example, I’m pretty sure Rails has contributed to improvements in PHP community (you can try to prove I’m wrong but I have a pretty vivid memory of Symfony framework taking heaps of inspiration from Rails). The same happened in Java (yes), Play framework is an example.

Now, architecture design issues aside - this was a good thing. Being inspired to think outside of the box and do something new is valuable. Rails contributed to that process on a large scale.

There are other aspects of Rails that are fantastic. Because Rails has been always focusing on the ease of usage and the ability to quickly build web applications, it made it possible for initiatives like Rails Girls to succeed. Rails has proven to people that they are capable of creating something on their own, without any programming experience, in a relatively short time. This _is amazing_, as it can easily become a gateway to the programming world for people who otherwise wouldn’t even consider becoming a programmer.

## My Journey

First of all, let me tell you a little bit about my background and where I’m coming from.

I started working with Ruby in late 2006, as my bachelor thesis was about Rails (yep). I’ve been learning the language while I was writing my thesis. It was fun, it was exciting, it was something new for me. Back then, I was still working as a PHP developer. As a typical PHP developer back in ~2005-6, I’ve done all the typical things - wrote raw SQL queries in view templates, choked on procedural PHP to death, then built my own framework, my own ORM, got frustrated and burned out. Despite knowing some C, C++, Java, and Python, I decided to go with Ruby, because of Rails. I picked it up for my thesis and completely accidentally stumbled upon a job offer from a local Rails shop. I applied, they hired me. It was in March of 2007.

And so since March 2007, I’ve been working with Ruby professionally, and since roughly 2009-10 I started contributing to Ruby OSS projects. During that time, I worked for a consultancy for 3.5 years, mostly working on big and complicated projects. I then went freelances for few years, worked with a bunch of clients, started my own company, then took a full-time gig, then went back to freelance again, and now I’m a full-time employee again. I built greenfield rails apps and I helped with medium-xxl rails apps.

Let me tell you a story about what can happen in a convoluted Rails codebase. Once, I joined an existing project. It was a _huuuuge_ app which was running an online shopping community website. Complicated sales model, complicated promotions, complicated product setups, coupons, user groups, messages - it had it all. I joined them to help ship a few new features. One of my early tasks was to…add a link to something on some page. It took me _few days to add this stupid link_. Why? The app was a big ball of complex domain logic scattered across multiple layers with view templates so complicated, it wasn’t even simple to find the right template where the link was supposed to be added. Since I needed some data in order to create that link, it wasn’t obvious how I should get it. There was a lack of internal application APIs and relying on ActiveRecord exclusively made it extremely difficult. I am not kidding you.

My initial frustrations with Rails started quite early. I’ve become displeased with ActiveRecord after roughly first 6 months of using it. I _never_ liked how Rails approached handling JavaScript and AJAX. In case you don’t remember or you were not around already before Rails adopted UJS approach (which was a big subject in ~2007-2008, with blog posts, conference talks and so on), it used inline Javascript generated by a bunch of nasty helpers. As everything with Rails, it was “nice and easy in the beginning” and then it would turn into unmaintainable crap. Eventually, Rails adopted UJS in the big version 3.0 rewrite and it seems like the community agreed that it’s a better approach. This was when Merb was killed by merged into Rails. Oh, you don’t know what Merb was? Right, let’s talk about that.

## Why I was excited about Merb & DataMapper

Merb was a project created by Ezra Zygmuntowicz. It started as a hack to make file uploads faster and thread-safe. It went through an interesting path from that hack to a full-stack, modular, thread-safe, fast web framework. I remember people started talking about it a lot in ~2008 and there was this amazing feeling that something new is happening and it’s gonna be great.

You might be excited about Rails adding “API mode”, right? Well, Merb had 3 modes: a full-stack mode, an API mode and a micro-mode where it was stripped down to a bare minimum and I still remember it was the fastest thing ever in the ruby land. **It was over 7 years ago**. Ponder on that.

At the same time, another project brought community attention - DataMapper. It became a part of The Merb Stack, being its ORM of choice. I got _really excited_ about it, as it addressed a lot of issues that ActiveRecord had. DataMapper back in ~2008-9 already had attribute definitions in models, custom types, lazy queries, more powerful query DSL and so on. In 2008, Yehuda Katz was one of the core contributors, he was [actively promoting](https://www.youtube.com/watch?v=-S5ADwI56_8) the project and there was a lot of excitement about it. DataMapper _was ultimately a better ORM than ActiveRecord in 2008-9_. It would be unfair not to mention that Sequel showed up already around the same time and till this day it’s being used way less than ActiveRecord despite being a superior solution.

I was excited about Merb and DataMapper as they brought hope that we can do things better and create a healthy competition for Rails. I was excited about it because both projects promoted a more modular approach and thread-safety, amongst other things like simply better Ruby coding standards.

Both projects were ultimately killed by Rails as Merb was [“merged”](http://yehudakatz.com/2008/12/23/rails-and-merb-merge/) into Rails, what turned out to be a major Rails refactor for its 3.0 version. DataMapper lost its community attention and without much support, it never evolved as it could if Merb was not “merged” into Rails.

With that decision, the Ruby ecosystem lost a bunch of important projects and only Rails benefited from this. Whether the decision to kill Merb was good or not is a matter of personal opinion, we can speculate what could’ve happened if the decision wasn’t made. However, there’s a simple truth about competition - it’s healthy. Lack of competition means monopoly, and there’s a simple truth about monopoly - it’s _not_ healthy. Competition fosters progress and innovation, competition creates a healthier ecosystem, it allows people to collaborate more, to share what’s common, to build better foundations. This is not what’s happening in the Ruby community.

After Merb & DataMapper were practically destroyed (in the long term), building anything new in the Ruby ecosystem turned out to be extremely difficult., Since peoples’ attention is Rails-focused, new projects have been highly influenced by Rails. Breaking through with new ideas is hard, to say the least, as every time you come up with something, people just want it to be Rails-like and work well with Rails. Making things work with Rails is hard, but I’ll get to it later.

After all these years we’ve ended up with one framework dominating our entire ecosystem, influencing thousands of developers and creating standards that are…questionable. We’ve lost a diverse ecosystem that started to grow in 2008 and was taken over by Rails.

Hey, I know how this sounds almost like a conspiracy theory, but don’t treat it like that. What I’ve said here are facts with a little bit of my personal feelings. I started contributing to DataMapper in late 2009 and seeing it crumble was very sad.

## Complexity!

Complexity is our biggest enemy. People have become less enthusiastic about Rails, because it quickly turned out that dealing with growing complexity leaves us with lots of unanswered questions. What DHH & co. have offered has been never enough to address many issues that thousands of developers started to struggle with already back in ~2007-2008. Some people hoped that maybe Merb/DataMapper will bring improvements but you know what happened now, so we were all back using Rails again in 2010, when Rails 3.0 was released.

A couple of days ago somebody posted on [/r/ruby](https://www.reddit.com/r/ruby/comments/4ip6dj/organize_your_app_with_service_objects/) a link to an article about organizing your code using “Service Objects”. This is one of many articles like that. If you think it’s some kind of a recent trend, go take a look at James Golick’s article from **March 2010** - [Crazy, Heretical, and Awesome: The Way I Write Rails Apps](http://jamesgolick.com/2010/3/14/crazy-heretical-and-awesome-the-way-i-write-rails-apps.html).

We’ve been talking about ways of improving the architecture of our Rails applications for roughly 6 years. I’ve been trying to contribute to this discussion as much as I could, with articles, conference talks and by working on many OSS projects that strive to solve various hard problems.

The arguments and ideas people have had are always being ridiculed by Rails Core Team members, and especially by DHH. This has been off-putting and discouraging for me, and the reason why I never tried to contribute to Rails. I’m pretty damn sure that my proposals would end up being drastically downvoted. Monkey-patches? C’mon, not a problem, we love our `10.years.ago`! New abstractions? Who needs that, Rails is SIMPLE! TDD? Not a problem, [it’s dead](http://david.heinemeierhansson.com/2014/tdd-is-dead-long-live-testing.html), don’t bother! ActiveRecord is bloated - so what, it’s so handy and convenient, let’s [add more features](https://github.com/rails/rails/pull/18910) instead!

Rails ecosystem, especially around its core team, has never made a good impression on me and I don’t have a problem admitting that I’m simply afraid of proposing any changes. This is especially so since the first issue I’d submit would be “Please remove ActiveSupport” (ha-ha…imagine that!).

OK let’s get into some tech details.

## Rails Convenience-Oriented Design

As I mentioned, Rails has been built with the ease of use in mind. Do not confuse this with simplicity. Just yesterday I stumbled upon this tweet, it says it all:

> Easy vs. Simple [pic.twitter.com/b6r0cTD6WO](https://t.co/b6r0cTD6WO)
> 
> — Dαve Cheney (@davecheney) [May 19, 2016](https://twitter.com/davecheney/status/733225955624263680)

This is how Rails works, a classic example:

```ruby
User.create(params[:user])
```

You see a simple line of code, and you can immediately say (assuming you know User is an AR model) what it’s doing. The problem here is that people confuse simplicity with convenience. It’s convenient (aka “easy”) to write this in your controller and get the job done, right?

Now, this line of code is not simple, it’s easy to write it, but the code is extremely complicated under the hood because:

- params must often go through db-specific coercions
- params must be validated
- params might be changed through callbacks, including external systems causing side-effects
- invalid state results in setting error messages, which depends on an external system (i.e. I18n)
- valid params must be set as object’s state, potentially setting up associated objects too
- a single object or an entire object graph must be stored in the database

This lacks basic separation of concerns, which is always damaging for any complex project. It increases coupling and makes it harder to change and extend code.

But in Rails world, this isn’t a problem. In Rails world, basic design guidelines like SRP (and SOLID in general) are being ridiculed and presented as “bloated, unneeded abstractions causing complexity”. When you say you’d prefer to model your application use cases using your own objects and make complex parts explicit, Rails leaders will tell you YAGNI. When you say you’d prefer to use composition, which makes your code more reliable and flexible, Rails leaders, except [tenderlove](https://twitter.com/tenderlove/status/734437704893505536), will tell you “use `ActiveSupport::Concerns`”.

For a Rails developer, it’s not a problem that **data coming from a web form are being sent to the depths of ActiveRecord** where God knows what will happen.

The really challenging part of this discussion is being able to explain that _it is a problem_ in the first place. **People are attracted by Rails because it gives you a false sense of simplicity**, whereas what really happens is that complexity is being hidden by convenient interfaces. These interfaces are based on many assumptions about how you’re gonna build and design your application. ActiveRecord is just one, representative example, but Rails is built with that philosophy in mind, every piece of Rails works like that.

I should mention that I know there are huge efforts to make ActiveRecord better, like introducing Attributes API (done through some serious internal refactoring which improved the code base). Unfortunately, as long as ActiveRecord comes with over 200 public methods, and encourages the use of callbacks and concerns, this will always be an ORM that will not be able to handle growing complexity, it’ll only contribute to this complexity and make things worse.

Will _that_ change in Rails? I don’t think so. We have zero indication that something can be improved as Rails leaders are simply against it. A simple proof is the recent controversial addition, `ActiveRecord.suppress` was [proposed by DHH himself](https://github.com/rails/rails/issues/18847). Notice how yet again he makes fun of standalone Ruby classes saying “Yes, you could also accomplish this by having a separate factory for CreateCommentWithNotificationsFactory”. Oh boy.

## ActiveCoupling

Should Rails be your application? This was an important question asked by many after watching Uncle Bob’s [talk](https://www.youtube.com/watch?v=WpkDN78P884), where he basically suggests a stronger separation between web part and your actual core application. Technical details aside, this is good advice, but Rails has not been designed with that in mind. If you’re doing it with Rails, you’re missing the whole point of this framework. In fact, take a look at what DHH said about this:

> [@paulca](https://twitter.com/paulca) Fuck. That. Shit. Same complete wank. “Rails is not your application”. If you’re building a web app, of course it is.
> 
> — DHH (@dhh) [June 29, 2012](https://twitter.com/dhh/status/218740829806792704)

It’s pretty clear what his thoughts are, right? The important part is “of course it is”. And you know what? I wholeheartedly agree!

**Rails is your application**, and it will always be unless you go through the enormous effort of using it in a way that it wasn’t meant to be used.

Think about this:

- **ActiveRecord is meant to become the central part of your domain logic**. That’s why it comes with its gigantic interface and plenty of features. You only break things down and extract logic into separate components when it makes sense, but Rails philosophy is to _put stuff to ActiveRecord_, not bother about SRP, not bother about LoD, not bother about tight coupling between domain logic and persistence and so on. That’s how you can use Rails effectively.
- The entire view “layer” in Rails is coupled to ActiveModel, thus making it coupled to an Active Record ORM (it could be Sequel, it doesn’t matter)
- Controllers, aka your web API endpoints, are an integral part of Rails, tight-coupling takes place here too
- Helpers, the way you deal with complex templates in Rails, are also an integral part of Rails, tight-coupling once again
- Everything in Rails, and in a plethora of 3rd party gems built for Rails, is happening through **inheritance (either mixins or class-based)**. Rails and 3rd party gems don’t typically provide standalone, reusable objects, they provide abstractions that your objects inherit - this is another form of tight-coupling.

With that in mind, it would be crazy to think that Rails is not your application. If you try to avoid this type of coupling, you can probably imagine what kind of an effort it would be and how much of the builtin functionality you’d lose - **and this is exactly why showing alternative approaches in Rails create an impression of bloated, unnecessary abstractions reminding people of their “scary” Java days**. Rails has not been built with loose-coupling and component-oriented design in mind.

Don’t fight it. Accept it.

## Not a good citizen

Having said all of that, **my biggest beef with Rails is actually ActiveSupport**. Since [I ranted about it](/2015/06/06/cutting-corners-or-why-rails-may-kill-ruby) already, I don’t feel like I need to repeat myself. I also recommend going through the comments in the linked blog post.

The only thing I’d like to add is that **because of ActiveSupport, I don’t consider Rails to be a good citizen in the Ruby ecosystem**. This library is everything that is wrong with Rails for me. No actual solutions, no solid abstractions, just nasty workarounds to address a problem at hand, **workarounds that turn into official APIs**, and cargo-culted as a result. Gross.

Rails is a closed ecosystem, and it imposes its bad requirements on other projects. If you want to make something work with Rails, you gotta take care of things like making sure it actually works fine when ActiveSupport is required, or that it can work with the atrocious code reloading in development mode, or that objects are being provided as globals because you know, in Rails everything should be available everywhere, for your convenience.

The way Rails works demands a lot of additional effort from developers building their own gems. First of all, it is expected that your gems can work with Rails (because obviously everybody is going to use them with Rails), and that itself is a challenge. You have a library that deals with databases and you want to make it work with Rails? Well, now you gotta make it work like ActiveRecord, more or less, because the integration interface is ActiveModel, originally based on ActiveRecord prior Rails 3.0.

There are _plenty of constraints_ here that make it very hard to provide integration with Rails.

You have no idea how many issues you may face when trying to make things work with hot code reloading in development mode. Rails expects a global, mutable run-time environment. To make it even harder for everybody, they introduced Spring. This gem opened up a whole category of potential new bugs that your gems may face while you try to make them work with Rails. I’m so done with this, my friends. **Not only is code reloading in Ruby unreliable, but it’s also introducing a lot of completely unnecessary complexity to our gems and applications**. This affects everybody who’s building gems that are supposed to work with Rails. Nobody from the Rails Core team, despite the criticism throughout the years, thought that maybe it’d be a good idea to see how it could be done better. If someone focused on making application code load faster, we could just rely on restarting the process. Besides, you should really use automated testing to see if a change you just made actually works, rather than hitting F5. Just saying.

I know it sounds like complaining because it is! I’ve tried to support Rails and it was just too frustrating for me. I’ve given up, I don’t want to do it anymore.

Since my solution to the problems I’ve had would mean ditching ActiveSupport, removing Active Record as the pattern of choice, and adding an actual view layer that’s decoupled from any ORM, I realized that it’s unreasonable to think this will ever happen in Rails.

## Leaving Rails

As a result of 9 freaking years of working with Rails and contributing like hell to many ruby OSS projects, I’ve given up. I don’t believe anything good can happen with Rails. This is my personal point of view, but many people share the same feelings. At the same time, there’s many more who are still happy with Rails. Good for them! Honestly! **Rails is here to stay, it’s got its use cases, it still helps people and it’s a mature, well maintained, stable web framework**. I’m not trying to convince anybody that Rails is ultimately bad! It’s just _really bad for me_.

This decision has had its consequences though. This is why I got involved with [dry-rb](http://dry-rb.org), [hanami](http://hanamirb.org) and [trailblazer](http://trailblazer.to) projects and why I’ve been working on [rom-rb](http://rom-rb.org) too. I want to help to build a new ecosystem that will hopefully bring back the same kind of enthusiasm that we all felt when Merb/DataMapper was a thing.

_We need a diverse ecosystem, we need more small, focused, simple and robust libraries. We need Rubyists who feel comfortable using frameworks as well as smaller libraries._

## (sort of) Leaving Ruby

Truth is, leaving Rails is also the beginning of my next journey - leaving Ruby as my primary language. I’ve been inspired by functional programming for the last couple of years. You can see that in the way I write Ruby these days. I’m watching Elixir growing with great excitement. I’m also learning Clojure, which at the moment is on the top of my “languages to learn” list. The more I learn it, the more I love it. My ultimate goal is to learn Haskell too, as I’m being intrigued by static typing. Currently, at work, I’ve been working with Scala. I could very quickly appreciate static typing there, even though it was a rough experience adjusting my development workflow to also include compilation/dealing with type errors steps. It is refreshing to see my editor telling me I made a mistake before I even get to running any tests.

The more I’m learning about functional programming, the more I see how Rails is behind when it comes to modern application design. Monkey-patching, relying on global mutable state, complex ORM, these things are considered as major problems in functional languages.

I know many will say “but Ruby is an OO language, use that to your advantage instead of trying to make it what it cannot be” - this is not true. First of all, Ruby is an OO language with functional features (blocks, method objects, lambdas, anyone?). Secondly, avoiding mutable state is a general, good advice, which you can apply in your Ruby code. Ditching global state and isolating it when you can’t avoid is also a really good general advice.

Anyhow, I’m leaving Ruby. I’ve already started the process. It’s gonna take years, but that’s my direction. I will continue working on and supporting rom-rb, dry-rb, helping with hanami and trailblazer, so don’t worry, these projects are very important for me and it makes me very happy seeing the communities growing.

## Common Feedback/Questions

This is a list of made up feedback and questions, but it’s based on actual, real feedback I’ve been receiving.

> Shut up. Rails is great and works very well for me.

This is the most common feedback I receive. First of all, it worries me that many people react like that. We’re discussing a tool, not a person, no need to get emotional. Don’t get me wrong, I understand that it’s natural to “defend” something that helped you and you simply like it, at the same time it’s healthy to be able to think outside of the box and be open to hear criticism and **just think about it**. If you’re happy with Rails, that’s great, really.

> You’re just complaining, you’re not helping, you haven’t done anything to help Rails become better, you haven’t suggested any solutions to the problems you’re describing

This type of feedback used to make me very angry and sad. In the moment of writing this, and according to GitHub, I made **2,435 contributions in the last year**. That was in my spare time. Yes, I haven’t contributed to Rails directly, because of the reasons I explained in this article. There’s too much I disagree with and it would’ve been a waste of time for both parties. I’ve been contributing through blog posts, conf talks and thousands of lines of OSS code that you can find on GitHub.

> It’s OSS, just fork it

This misses the point completely. We need diversity in the ecosystem with a good selection of libraries, and a couple of frameworks with their unique feature-sets making them suitable for various use cases. A fork of Rails would make no sense. Nobody would fork Rails to go through a struggle like removing ActiveSupport and de-coupling the framework from concepts like Active Record pattern. It’s easier and faster to build something new, which other people are already doing (see [Hanami](http://hanamirb.org)).

> Just don’t use Rails

I did stop using Rails last year, but it’s not happening “just like that”. Being a Ruby developer means that in 99% of the cases your client work will be Rails. Chances of getting a gig without Rails are close to 0. “Selling” alternative solutions for clients is risky unless you are 100% sure you’re gonna be the one maintaining a project for a longer period.

What happens _right now_ is that some businesses, in most of the cases, have two choices: go with Rails or not go with Ruby and pick a completely different technology. People won’t be looking at other solutions in Ruby, because they don’t feel confident about them and they are not interested in supporting them. I’m talking about common cases here, there are exceptions but they are extremely rare.

> OK cool, but what are you suggesting exactly?

My suggestion is to **take a really good look at the current ruby ecosystem and think about its future**. The moment somebody builds a web framework in a better language than Ruby, which provides similar, fast-pace prototyping capabilities, Rails might become irrelevant for businesses. When that happens, what is it that the Ruby ecosystem has to offer?

If we want Ruby to remain relevant, we need a stronger ecosystem with better libraries and alternative frameworks that can address certain needs better than Rails, so that businesses will continue to consider using Ruby (or keep using Ruby!). We’ve got over a decade of experience, we’ve learned _so much_, we can use that to our advantage.

> You obviously have some personal agenda. I don’t trust your judgements.

I don’t! I’ve got my OSS projects, I’m working on a book, I have a rom-rb donation campaign and I understand that this creates an impression that I simply look to gain something here.

That’s not true, this is not why I’m doing it. I’ve been working so hard first and foremost because I enjoy learning, experimenting, collaborating with people and simply because I care about Ruby’s future. The reason why I decided to write a book is that explaining all the new concepts we’ve introduced in various libraries is close-to-impossible without a book.

My donation campaign was started because I’ve invested countless hours into the project and I couldn’t continue doing that because I was too busy with client work and, you know, something called life.

Thanks to [Srdjan Pejic](https://twitter.com/batasrki) for proof-reading
