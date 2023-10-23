---
title: Get Rid of That Code Smell – Primitive Obsession
date: '2012-06-25'
categories:
- blog
tags:
- archives
- blog
- oop
- refactoring
- ruby
slug: get-rid-of-that-code-smell-primitive-obsession
aliases:
- "/2012/06/25/get-rid-of-that-code-smell-primitive-obsession"
---

This is a post from the [Get Rid of That Code Smell](http://solnic.codes/2012/03/30/get-rid-of-that-code-smell.html "Get Rid of That Code Smell") series.

* * *

Primitive Obsession is another popular code smell in Ruby land. It’s very easy, tempting and just feels convenient to use primitive objects to represent various concepts in our code. Here are some primitive classes in Ruby that we like to be obsessed about:

- Array
- Hash
- String
- Fixnum
- Float

Whenever you use one of these classes in a context where they don’t actually fit being semantically incorrect, that’s when you introduce Primitive Obsession code smell. Nothing explains it better than a few simple examples:

- a string representing a URI
- a float number representing money
- a hash representing a set of objects

Think about it this way: would you use a string to represent a date? You could, right? Just create a string, let’s say `"2012-06-25"` and you’ve got a date! Well, no, not really - it’s a string. It doesn’t have semantics of a date, it’s missing a lot of useful methods that are available in an instance of `Date` class. You should definitely use `Date` class and that’s probably obvious for everybody. This is exactly what Primitive Obsession smell is about.

## Detecting Primitive Obsession Smell

Unfortunately I’m not aware of any tools that would know how to detect this smell so you need to rely on your own analysis. If you have a good understanding of the domain you’re dealing with it should be fairly easy to detect the smell. Simply look for cases where primitive ruby objects are being used intensively in domain specific contexts. Monkey patching primitive classes could also be considered as a smell indicator.

Here’s an example of the smell from Virtus project, a hash with attributes:

```generic
module Virtus
  module ClassMethods

    # Returns all the attributes defined on a Class.
    #
    # @return [Hash]
    #   an attributes hash indexed by attribute names
    #
    # @api public
    def attributes
      @attributes ||= {}
    end

  end
end

```

What happens here is that we use `Hash` to represent a set of attributes. It just feels convenient to use a hash here, we want to access attribute objects via `#[]` method and hash gives us that for free. What we forget about is that we don’t really need a hash, we need something with set semantics and methods to add and merge attributes. Building such API on top of Hash is a mistake.

## Removing Primitive Obsession Smell

It’s easy, just come up with a rich object that has correct semantics and exposes API that you need. The attributes hash in Virtus was replaced with an instance of `Virtus::AttributeSet`.

Here’s its piece (full source is [here](https://github.com/solnic/virtus/blob/master/lib/virtus/attribute_set.rb)):

```generic
module Virtus

  # A set of Attribute objects
  class AttributeSet
    include Enumerable

    def initialize(parent = nil, attributes = [])
      @parent       = parent
      @attributes   = attributes.dup
      @index        = {}
      reset
    end

    def each
      return to_enum unless block_given?
      @index.values.uniq.each { |attribute| yield attribute }
      self
    end

    def <<(attribute)
      self[attribute.name] = attribute
      self
    end

    def [](name)
      @index[name]
    end

    def []=(name, attribute)
      @attributes << attribute
      update_index(name, attribute)
    end
  end
end

```

The class exposes smaller API than `Hash` and at the same time has additional responsibility that we needed (dealing with attributes from a parent). With a primitive hash object we would have to put this responsibility in a place where it wouldn’t really belong. win-win.

## Summing Up

In OOP it’s important to use rich objects representing various concepts from your domain. Implement `Money` class if you need to deal with money, it’s much better than using floats all over the place. Don’t use `Hash` for configuration objects, use a custom `Configuration` class instead. Have fun with `GeoLocation` class instances rather than having pairs of latitude and longitude values embedded inside other objects. This way you will achieve better encapsulation and slim API.

Next stop: we’re going to take a look at Feature Envy.
