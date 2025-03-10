---
title: Rails and its Ruby dialect
date: 2022-02-02
aliases:
- "/2022/02/02/rails-and-its-ruby-dialect"
- "/rails-and-its-ruby-dialect"
categories:
- blog
tags:
- archives
- ruby
- rails
- community
slug: rails-and-its-ruby-dialect
---

> This was originally titled "Rails is not written in Ruby" but based on feedback, I decided to change the title.

I'm born and raised in Kraków, a beautiful city in Poland, maybe you've heard about it, maybe you've even been here. In Poland we speak Polish, which is a really difficult language, it's actually considered one of the top-10 most difficult languages to learn in the world. In Poland, just like in many other countries, there are regions where dialects are used rather than "the pure" form of the language, and so in my city, we have our own dialect. It's not *too different* from Polish, but we have our special words, and a special way of saying certain words. For example, we say "czy", which means "three", even though the correct form is "trzy", but we're like "that's too hard" so we keep it simple, "czydzieści czy" (33) instead of "trzydzieści trzy". The rest of Poland is making fun of us because of this kind of stuff, but whatever, it's our dialect - this is how we like to speak.

What does it have to do with Rails and Ruby though? Good question. Programming languages have dialects as well, by definition, a programming language dialect is "a (relatively small) variation or extension of the language that does not change its intrinsic nature". It doesn't really matter how exactly such variation or extension is implemented. The important part is that the original language is extended and it provides more functionality, while it's original nature and behavior stay the same.

This brings us to Ruby - a programming language with open classes, where even the core functionality of the language can be **extended** by simply adding new methods to core classes, like `String` or `Array`. This makes it very simple to create your own Ruby dialect!

This unique feature of Ruby has been leveraged by DHH back when he created Ruby on Rails framework. The very foundation of this framework is a library called ActiveSupport - **a big** collection of **core Ruby extensions**, which together create **a Ruby dialect**, an extended version of the Ruby language, which doesn't change it's intrinsic nature. Why is it a foundation of the framework, you may ask - the answer is very simple: everything would break if you tried to remove ActiveSupport from Rails.

What does it actually mean if you take into consideration the entire Ruby ecosystem though?

## Monopoly for monkey-patching

Monkey-patching is another way of saying that some piece of code alters an existing class by leveraging open classes in Ruby. The ActiveSupport library monkey-patches many classes, there are currently `3471 LOC` in its `core_ext` directory. Here, I've generated some stats:

```ruby
{Array=>{:original_methods=>196, :as_methods=>251, :added_by_as=>55},
 Class=>{:original_methods=>117, :as_methods=>172, :added_by_as=>55},
 Date=>{:original_methods=>132, :as_methods=>240, :added_by_as=>108},
 DateTime=>{:original_methods=>142, :as_methods=>277, :added_by_as=>135},
 File=>{:original_methods=>236, :as_methods=>279, :added_by_as=>43},
 Hash=>{:original_methods=>182, :as_methods=>246, :added_by_as=>64},
 Integer=>{:original_methods=>148, :as_methods=>206, :added_by_as=>58},
 Module=>{:original_methods=>114, :as_methods=>165, :added_by_as=>51},
 Object=>{:original_methods=>63, :as_methods=>83, :added_by_as=>20},
 Range=>{:original_methods=>133, :as_methods=>171, :added_by_as=>38},
 String=>{:original_methods=>188, :as_methods=>256, :added_by_as=>68},
 Symbol=>{:original_methods=>92, :as_methods=>114, :added_by_as=>22},
 Time=>{:original_methods=>121, :as_methods=>257, :added_by_as=>136}}
```


> When you count them all, you get **853 instance methods added to the core classes**.

Notice that I'm only talking about the core extensions. I skipped classes from the stdlib! I also counted only public instance methods. It would be interesting to see how many class and private methods ActiveSupport adds. This would be a fun excercise.

When you have a library, a ruby gem, which adds such a significant amount of new methods to the core classes, it is important to understand that:

- You are no longer using Ruby, you are now using a Ruby dialect, implemented as a library called ActiveSupport
- You **must be aware** that the methods that **you are adding** to **your own classes in your application's code** could potentially cause conflicts with ActiveSupport
- It is **a very bad idea** to build other libraries, that also monkey-patch core classes, because they can cause conflicts as well

Some time ago, we had a lot of ruby gems that would also rely on monkey-patching. We even had a full-stack framework that was meant to compete with Rails. It was called Merb and it also had something like ActiveSupport, it was called extlib. As you probably guessed - it caused conflicts with ActiveSupport so it wasn't really feasible to use both libraries in the same codebase. Merb and Rails "merged" into Rails 3 though, and that's how we don't have "an extlib problem" anymore, because the library is gone. Over time, many Ruby developers working on various gems have learned the downsides of monkey-patching and simply stopped doing it. RSpec is our primary example here - a limited and problematic DSL based on monkey-patching was turned into a beautiful, composable DSL which we still have in RSpec.

Unfortunately, even though majority of the gems stopped relying on monkey-patches, we still have ActiveSupport just because it's such a fundemental part of Rails. After all, the framework is written in ActiveSupport Ruby dialect!

Here's the crux of the problem though:

> an API which is implemented as part of a Ruby dialect looks "nicer", more concise and natural

Why? Because it **looks like part of the language**! This is why things like `1.day.ago` looks so "natural". Except that it's not Ruby - it's ActiveSupport.

When you think about it, you may realize that this is a huge advantage that Rails has over **every other library out there** - it's got monopoly for monkey-patching.

## Ecosystem-wide implications

For people like me, who are working on Ruby libraries, experiencing constant pushbacks and negative feedback every time you try to show how to approach certain problems is just daunting. It happens quite often that you show something now and all you hear is "that's too complicated". The reason why something seems to be "more complicated" is that **you actually use Ruby**, with objects, and encapsulation of behavior...rather than chucking in whatever you want in any class that you happen to find useful.

> ! it was brought to my attention that this paragraph makes it seem like I'm frustrated and creates an impression that the article is toxic as I'm making Rails look bad - to clarify: I'm not frustrated, far from it, sometimes I feel tired and lose motivation, but it's just "a bad day". My intention with this paragraph was to express *how Ruby library authors may often feel*, which is based on my past experience. My intention with the entire article was to *explain* what ActiveSupport actually is so that you can have some perspective, which I believe many people don't have. This is why discussing Ruby code is sometimes challenging, due to the lack of this perspective.

If you consider the entire Ruby ecosystem, this is a real problem. First of all, you compete using plain Ruby with the ActiveSupport dialect - in most cases you've lost before you even started coding, because most Ruby developers won't like whatever you're going to build. People have certain expectations from Ruby libraries and they are **heavily influenced by their experience with Rails and its dialect**.

Another rather negative implication is that Rails, through ActiveSupport, has created a massive confusion about what is Ruby vs what is Ruby with ActiveSupport. This has never been a good thing. Trust me, there are people in other programming communities who dislike Ruby when in reality, they actually dislike Rails! People confuse the two all the time.

## BUT MANY METHODS FROM ACTIVESUPPORT ARE NOW IN RUBY!!

Yes, and? This is not an argument that can justify monkey-patching. If you want to experiment with new methods, do it in isolation, in your own codebase. If you feel good about what you came up with - report an issue in the Ruby tracker suggesting a new method addition.

This also goes back to what I previously mentioned: monopoly for monkey-patching. It's not OK that there's this one library with special treatment that can monkey-patch pretty much whatever and then some of its patches can end up in the language itself.

## Technical and design implications

I often mention that monkey-patching isn't even a sound technical solution, simply because you can't compose monkey-patches, there's lack of encapsulation and proper boundaries and, to make things worse, it can easily lead to naming conflicts. Let's break this down:

### Lack of composability

Composability is a very powerful technique. In Ruby, it can be easily achieved by simply using objects. In functional language, you can simply compose functions. What does it mean to compose functionality? It just means that you take functionality X, and functionality Y, and you turn it into functionality Z which combines the two in such a way, that X and Y are hidden (which is called encapsulation, but I'll get to this part later).

Here's why this doesn't work so well in case of ActiveSupport (and monkey-patching in general). Let's say you have a number and you want to format it, ActiveSupport provides a `to_formatted_s` method implemented as a Numeric core extension:

```ruby
987654321.to_formatted_s(:phone, area_code: true)
=> "(98) 765-4321"
```

Cool, right? So natural, look at this beautiful piece of ~~Ruby~~ ActiveSupport dialect.

Now, imagine that you need to preprocess the number somehow, maybe you need to trim it and remove some junk. What do you do?

```ruby
 "  HUH987654321  ".strip.gsub(/\AHUH/, "").to_i.to_formatted_s(:phone, area_code: true)
=> "(98) 765-4321"
```

OK, you're still covered by Ruby and ActiveSupport, let's say you can live with this for some time but then you realize you need to validate the string (as you should) before doing anything with it. What do you do? This?:

``` ruby
class String
  def validate_phone_number
    # ...
  end
end

"  HUH987654321  ".strip.gsub(/\AHUH/, "").validate_phone_number.to_i.to_formatted_s(:phone, area_code: true)
```

If you're shaking your head that it would be a bad idea then of course you're right, but guess what - **people used to do that**! In fact, I bet there are people who still do that! Overall, the consensus within the community **has been for years** that it is indeed a bad idea and a massive code smell. Most experienced Ruby developers don't monkey-patch core classes anymore.

### Lack of encapsulation and unclear boundaries

Encapsulation is important because it allows you to achieve composability, pluggability, extensibility and in general makes your code much easier to work with. If boundaries are not clear, unrelated functionality gets mixed together either by an accident or simply by making bad design decisions (or not making any design decisions at all). Your code becomes less and less cohesive and as a result you will inevitably end up in misery.

Numbers are primitive values, they shouldn't be coupled to details like phone formatting. Sure, it's convenient and looks cute but it comes with serious drawbacks. First of all **you can't keep adding more and more monkey-patches**. There's a limit. Once you reach this limit, you will start implementing domain-specific functionality in a different way - this is where your code already starts losing cohesion and this is also how things become less composable. You're no longer chaining methods, you now have a separate abstraction to do more heavy work but it's not part of the Number API, because it would be too much.

> with monkey-patching approach you're making boundaries within your system less clear.

This is a simple consequence of putting things in places where they don't belong. Monkey-patches like `to_formatted_s` are honestly just helpers, helpers attached to core classes. They are only needed in very specific places; however, they are provided globally due to the nature of monkey-patching! Every core object has these methods after all. This, in turn, makes it possible to reach out for them anywhere in your code base.

> ! Please also see my comment [here](https://solnic.codes/2022/02/02/rails-is-not-written-in-ruby/#comment-5719695778)

### Naming conflicts

This is probably the most obvious drawback. If you throw encapsulation out of the window and assume that it's OK to monkey-patch, then it's easy to imagine a situation where two people come up with the same method name, implement them as a monkey-patch in the same class and now you have a problem.

Let me remind you once again: we used to have plenty of gems shipping with monkey-patched core classes, it caused a lot of trouble, we've stopped doing it because it was wrong. Simple.

## OK so what's the alternative?

Ruby! For the love of Matz, the alternative is to just use Ruby. You can achieve **amazing things** with this language without having to alter core classes. It's not just about core classes though. There are so many libraries out there that integrate with other libraries by...yes, by monkey-patching them. In a way, I see this as a result (a legacy?) of Rails and the mindset behind it. This is what we have learned to do, but we can do better.

How can you achieve composability? You use object composition. It can be as simple as `Z.new(x: X.new, y: Y.new)`. You don't want to write code like that? I know, me neither. That's why there are libraries with nice abstractions and DSLs. Go look around, they exist.

Do take a look at RSpec's evolution. How it went from `"foo".should eql("foo")` to `expect("foo").to eql("foo")`. I don't think anybody misses the old syntax. I'm sure there are more examples of such transitions, let me know if you remember them.

If you think ActiveSupport's time helpers cannot be replaced, then take a look at [time_calc](https://github.com/zverok/time_calc) gem. There is a significant difference between composable time calculations vs a bunch of time helper methods attached to integers.

# To be continued!

I really wanted to provide some concrete examples but this would be too much. I'm gonna publish this to get it out of my head but I'm more than happy to keep discussing this subject, as you can see I'm quite passionate about it 😉.

For the time being, I would love if you checked out OSS libraries that me and many other people have been working on for years now. Things will be much simpler for me to just "show off" once we're done with [Hanami 2.0](https://hanamirb.org) final but for now, check out [dry-rb](https://dry-rb.org) - it's a great example how libraries can be implemented without monkey-patching, they are all composable and unobtrusive, so you can add them easily to an existing code base. You may also discover how well they play with other libraries!

I'm open to your feedback, questions and concerns (no pun intended!). I think I want to keep on working on this article, maybe turn it into a sticky page or something here. It's not the first time when I talk about this topic, and I actually really don't like to repeat myself, but I would like to have a single resource that I could simply point people to whenever I find myself complaining about ActiveSupport on Twitter again 🤭.
