---
title: Get Rid of That Code Smell - Control Couple
date: '2012-04-11'
categories:
- blog
tags:
- archives
- blog
- metrics
- oop
- refactoring
- ruby
- srp
slug: get-rid-of-that-code-smell-control-couple
aliases:
- "/2012/04/11/get-rid-of-that-code-smell-control-couple"
---

This is a post from the [Get Rid of That Code Smell](http://solnic.codes/2012/03/30/get-rid-of-that-code-smell.html "Get Rid of That Code Smell") series.

If you are serious about Object Oriented Design and respecting Single Responsibility Principle then you definitely want to get rid of Control Couple code smells. In this post I will show you a simple example explaining how to identify and remove control coupling from your code. I like to think about that code smell also in the context of SRP because I like to apply it to every piece of my system - whether it’s a method, a class or a whole library. I like to be able to describe each piece with a simple sentence saying what it does, what’s the responsibility. With control coupling you introduce multiple responsibilities in a single method which is against SRP and against Object Oriented Design.

## Detecting Control Couple Smell

[Reek](https://github.com/kevinrutherford/reek "reek on github") can help you with that - detecting Control Couple is turned on by default. I believe that [Pelusa’s](https://github.com/codegram/pelusa "pelusa on github") “Else Clause” and “Case Statement” lints can also be used to find places in your code with potential control coupling.

A dead-simple example of control coupling could like this:

```generic
def say(sentence, loud = false)
  if loud
    puts sentence.upcase
  else
    puts sentence
  end
end

```

Which is pretty self-explanatory. The `say` method puts an upcased sentence if `loud` parameter is set to `true`.

Let me show you a real-world example though. Let’s bring it to the class level - here’s a small snippet from [Virtus](https://github.com/solnic/virtus "virtus on github"):

```generic
class DefaultValue

  def initialize(value)
    @value = value
  end

  def evaluate(instance)
    if callable?
      call(instance)
    elsif duplicable?
      @value.dup
    else
      @value
    end
  end

end

```

`DefaultValue` is a class responsible for evaluating a default value of an attribute in Virtus. Its `#evaluate` method, depending on `@value` ivar, is deciding **how** to evaluate the value. We have multiple cases here and all of them are handled within one method. You cannot easily describe this method’s responsibility because it does different things depending on what the `@value` ivar actually is. If it’s a proc-like object responding to `#call` we call it, if it’s a duplicable object then we dup it, else we just return it as is.

I found that code pretty ugly. The repercussion of Control Couple smell in this example was that every time we were setting the default value we were performing this if/else check on `@value`.

## Removing Control Couple Smell

The `DefaultValue` class was refactored by splitting the evaluate logic into 3 sub-classes. Every sub-class implements a `self.handle?` method which checks if its instance can actually handle the given value. This means that the logic inside `#evaluate` is now performed only once, prior to deciding which `DefaultValue` sub-class we want to initialize.

Here’s how it looks like:

```generic
class DefaultValue
  DESCENDANTS =  [ FromSymbol, FromCallable, FromClonable ].freeze

  def self.build(*args)
    klass = DESCENDANTS.detect { |descendant| descendant.handle?(*args) } || self
    klass.new(*args)
  end

  def initialize(value)
    @value = value
  end

  # default implementation - simply return the value as is
  def evaluate(*)
    @value
  end
end

```

Now for example `FromCallable` class implementation looks like that:

```generic
class FromCallable < DefaultValue

  def self.handle?(value)
    value.respond_to?(:call)
  end

  # evaluates the value via value#call
  def evaluate(*args)
    @value.call(*args)
  end

end

```

I liked that refactor because I could remove the if/else clause from `#evaluate` method, split responsibilities across 3 sub-classes and gain a small performance boost too.

## Summing Up

Even if removing Control Couple smell requires writing a bit more code - it’s worth that price. Getting rid of that smell leads to better Object Oriented Design and helps you with respecting Single Responsibility Principle. I also like that it’s easier to understand what the code does because responsibilities are shared across the objects rather than jamming everything into a few methods that couple the logic to the received arguments.

In the next post we’ll see how to deal with Duplication in our code. Stay tuned.
