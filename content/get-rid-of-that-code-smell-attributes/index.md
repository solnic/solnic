---
title: Get Rid of That Code Smell - Attributes
date: '2012-04-04'
categories:
- blog
tags:
- archives
- blog
- metrics
- oop
- refactoring
- ruby
slug: get-rid-of-that-code-smell-attributes
aliases:
- "/2012/04/04/get-rid-of-that-code-smell-attributes"
---

In this post I will show you why using attribute accessors is a code smell in most of the cases. This is a very convenient feature of Ruby but you should only consider using it if you’re implementing a data-like objects which expose, well, data to other parts of your system. A good example is an Active Record object which exposes its attributes. Another good example could be an object which wraps a response from a remote API and through attribute readers gives you access to data returned in that response. Probably every other use case should be considered as a code smell.

## Detecting Attribute Smell

It’s pretty easy to find the attribute smell in your code. Just grep for usage of attr_\* in your classes. <a href=“https://github.com/codegram/pelusa” title=“pelusa on github” target=“_blank”>Pelusa does that for you. [Reek](https://github.com/kevinrutherford/reek "reek on github") can also detect this smell although this check is turned off by default.

Here’s an attribute class which you can instantiate with a name and set its reader visibility. This is an actual piece of code that we used to have in [Virtus](https://github.com/solnic/virtus "virtus on github"). The information about reader visibility needed to be public. Initially we had a public `attr_reader` for the `reader_visibility` instance variable that was set in the constructor. It was an easy and convenient solution. The related piece of code looked like that:

```generic
class Attribute
  attr_reader :reader_visibility

  def initialize(name, options = {})
    # some stuff
    @reader_visibility = options.fetch(:reader, :public)
  end
end

```

Now in other places we were using the value of `reader_visibility` so we had pieces of code like this:

```generic
if attribute.reader_visibility == :public
  # do something
end

```

This means that we had an instance variable exposed to the other objects which were relying on its value. This was a mistake and definitely a code smell.

## Removing Attribute Smell

You probably know how to get rid of that smell, right? We should simply implement a predicate method and this is exactly what was done:

```generic
class Attribute
  # stuff

  def public_reader?
    @reader_visibility == :public
  end
end

attribute = Attribute.new(:name, :reader => :public)
attribute.public_reader? # => true

```

This is much better because of two reasons. First of all we hide the private state of an object behind a public predicate method which is simply cleaner. Secondly if, for some reason, the logic for calculating the value of `reader_visibility` becomes more complex we will simply implement that in the predicate method. Well, it’s probably not going to be the case here but you get the idea.

## What about “Tell, Don’t Ask”?

This rule is also related to the attribute smell. Whenever you rely on an object’s attribute to make a decision what to do next - you’re violating “Tell, Don’t Ask” and you’re introducing the attribute smell. Here’s a quick example:

```generic
library = Library.new

# bad
if library.books.size > 0
  library.do_some_stuff_with_books
end

# good
library.do_some_stuff_with_books

```

This subtle difference is important because the library object should know how to deal with an empty books array and it should not be a concern “outside” of the library object. We also rely on the books property which indicates the attribute smell.

## Summing Up

As you can see the attribute smell is easy to find and fix. The important thing to remember is that when you rely on the internal state of the objects you make future refactorings very difficult. So just don’t do that. Objects should expose as little information about their internal state as possible. Make things publicly visible only if you’re certain it’s really really needed. Rely on API that your objects provide instead of their internal state. This will make your life much easier.

In the next post we’ll deal with the “Control Couple” smell.
