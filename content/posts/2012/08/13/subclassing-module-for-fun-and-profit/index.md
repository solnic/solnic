---
title: "Subclassing Module For Fun and Profit"
date: "2012-08-13"
categories: 
  - "blog"
tags: 
  - "blog"
  - "experimental"
  - "oop"
  - "ruby"
---

You think you’ve done everything with Ruby? How about subclassing Module? It’s an interesting technique that I’ve been experimenting with lately. One of the downsides of using modules in Ruby is that a module doesn’t have a state. When you mix it into another class you’re basically copying methods from one place to another. What if extending an object with new methods requires a state? Where would you put that state?

A good example is what every ORM out there does - adding attribute accessor methods. Let’s take a look how it’s usually done:

```generic
class Book
  title_accessor = Module.new do
    def title
      # some orm magic to return a title
      @title
    end

    def title=(title)
      # some orm magic to set a title
      @title = title
    end
  end

  include title_accessor

  def title
    "#{super} + super works!"
  end
end

book = Book.new
book.title = "Module Subclassing Guide"
puts book.title

```

See that anonymous module? We define accessor methods in that module and then we include it into the Book class. The class has now both reader and writer defined and you are free to overwrite them and call `super`.

The downside of this approach is that we create an anonymous module that’s missing a state. If you inspect that module it won’t tell you anything useful apart from `#Module:0x007f9e3b84f770>`. The module doesn’t know what’s the name of the attribute it defines accessors for. That information can be important and it would be nice to encapsulate that knowledge in a single place.

It turns out it is possible to subclass `Module` to capture a state. Check out this example:

```generic
class AttributeAccessor < Module
  def initialize(name)
    @name = name
  end

  def included(model)
    super
    define_accessors
  end

  private

  def define_accessors
    ivar = "@#{@name}"
    define_writer(ivar)
    define_reader(ivar)
  end

  def define_writer(ivar)
    define_method("#{@name}=") do |value|
      instance_variable_set("#{ivar}", value)
    end
  end

  def define_reader(ivar)
    define_method(@name) do
      instance_variable_get("#{ivar}")
    end
  end
end

class Book
  include AttributeAccessor.new(:title)

  def title
    "#{super} + super works!"
  end
end

book = Book.new
book.title = "Module Subclassing Guide"
puts book.title

```

What did just happen?! So. Instead of an anonymous module, we create a module subclass and instantiate it passing the name of the attribute that we want to define accessors for. It’s no longer a dumb module with some methods. It’s a dynamic module instance that knows how it should define accessors on the classes that are extended by it. Sounds crazy. I know. But it works and it can allow to build methods dynamically in a much cleaner fashion than the “standard” anonymous modules approach.

So what do you think? Crazy? Dangerous? Or maybe just purely awesome and useful? Maybe you have used this technique too? I would love to learn about other use cases.

This technique has been brought to you by [Emmanuel Gomez](https://github.com/emmanuel/) - thanks man for messing with our brains :)
