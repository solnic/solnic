---
title: Get Rid of That Code Smell – Duplication
date: '2012-05-11'
categories:
- blog
tags:
- archives
- blog
- metrics
- oop
- refactoring
- ruby
slug: get-rid-of-that-code-smell-duplication
aliases:
- "/2012/05/11/get-rid-of-that-code-smell-duplication"
- "/get-rid-of-that-code-smell-duplication"
---

This is a post from the [Get Rid of That Code Smell](http://solnic.codes/2012/03/30/get-rid-of-that-code-smell.html "Get Rid of That Code Smell") series.

* * *

Removing duplication from the code is a seemingly easy task. In many cases it is pretty straight-forward - you look at similar bits of code and you move them to a common method or class that is reusable in other places. Right? No, not really. It is true that code that looks similar might be an indicator that there’s a duplication but it’s not the definitive way of determining the smell.

If we look for duplication in our code we should look for duplicated **concepts** instead of similarly looking lines of code. Here I want to remind you the short definition of DRY principle that I’m sure most rubyists are familiar with:

> Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
>
> **Andrew Hunt and David Thomas** [The Pragmatic Programmer](http://pragprog.com/the-pragmatic-programmer)

There is a fantastic presentation by David Chelimsky from RubyConf 2010 titled “Maintaining Balance While Reducing Duplication”. If you missed it you should definitely check it out. There’s a beautiful quote in this talk:

> DRY does not mean “don’t type the same characters twice”
>
> **David Chelimsky** [Maintaining Balance While Reducing Duplication](http://www.confreaks.com/videos/434-rubyconf2010-maintaining-balance-while-reducing-duplication)

## Detecting Duplication Smell

You can use both [reek](https://github.com/kevinrutherford/reek "reek on github") and [flay](http://ruby.sadi.st/Flay.html "Flay") to aid you with finding duplication in your code but remember that these tools are not smart enough to find similar concepts. Both will find **potential** duplication but it’s your job to decide if it makes sense to do anything about it.

Here is an example from [Virtus](https://github.com/solnic/virtus "virtus on github") project where reducing duplication **wasn’t** such a good idea:

```generic
module Virtus
  module ValueObject
    module Equalizer < Module

      # some stuff

      def define_eql_method
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def eql?(other)
            return true if equal?(other)
            instance_of?(other.class) &&
            #{@keys.map { |key| "#{key}.eql?(other.#{@key})" }.join(' && ')}
          end
        RUBY
      end

      def define_hash_method
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def hash
            self.class.hash ^ #{@keys.map { |key| "#{key}.hash" }.join(' ^ ')}
          end
        RUBY
      end
    end
  end
end

```

The `Equalizer` module defines a bunch of methods. Internally it has a few private `define_*` methods which use `@keys` ivar to map it to something else. Now the metric tools complained about all these calls to `@keys.map`. It is true, this is a duplicated code but what’s the risk that it’s going to change? Very, very small. Is this a duplicated concept in the library? Nope.

Nevertheless I went ahead and reduced this duplication by introducing a new method so the code looked like that:

```generic
module Virtus
  module ValueObject
    class Equalizer < Module

      # some stuff

      def define_eql_method
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def eql?(other)
            return true if equal?(other)
            instance_of?(other.class) &&
            #{compile_keys(' && ') { |key| "#{key}.eql?(other.#{key})" }}
          end
        RUBY
      end

      def define_hash_method
        module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def hash
            self.class.hash ^ #{compile_keys(' ^ ') { |key| "#{key}.hash" }}
          end
        RUBY
      end

      def compile_keys(separator = ' ', &block)
        keys_map = @keys.map { |key| yield(key) }
        keys_map.join(separator)
      end
    end
  end
end

```

Now the metric tools won’t complain. All the calls to `@keys.map` has been replaced with a call to the new `compile_keys` method.

This refactor did reduce duplication but with the price of **increased complexity**. I don’t think it was such a great idea - the risk that these duplicated calls would have to change was so low that I should’ve left this code alone despite the little duplication.

## Removing Duplication

Here’s another example where it actually did make sense to reduce duplication to get cleaner code and better encapsulation:

```generic
module Virtus
  class Coercion
    module TimeCoercions

      def to_string(value)
        value.to_s
      end

      def to_time(value)
        if value.respond_to?(:to_time)
          value.to_time
        else
          Coercion::String.to_time(to_string(value))
        end
      end

      def to_datetime(value)
        if value.respond_to?(:to_datetime)
          value.to_datetime
        else
          Coercion::String.to_datetime(to_string(value))
        end
      end

      def to_date(value)
        if value.respond_to?(:to_date)
          value.to_date
        else
          Coercion::String.to_date(to_string(value))
        end
      end

    end
  end
end

```

I think it’s easy to see duplication here. The duplicated concept is that we want to call a specific method on the value only if it’s actually available. If it’s not then we use an alternative String-based coercion.

This logic was extracted into a new method called `coerce_with_method` and the module looked like that:

```generic
module Virtus
  class Coercion
    module TimeCoercions

      def to_string(value)
        value.to_s
      end

      def to_time(value)
        coerce_with_method(value, :to_time)
      end

      def to_datetime(value)
        coerce_with_method(value, :to_datetime)
      end

      def to_date(value)
        coerce_with_method(value, :to_date)
      end

      def coerce_with_method(value, method)
        value.respond_to?(method) ? value.public_send(method) : Coercion::String.send(method, to_string(value))
      end
    end
  end
end

```

In fact this turned out to be so common that later on `coerce_with_method` was moved to the base `Virtus::Coercion::Object` class with a few overridden variations in other coercion sub-classes.

## Summing Up

Reducing duplication should be based on finding similar concepts, not similarly looking code. The metric tools can only point you to potential duplication but you have to determine yourself if it really makes sense to do anything about it. In some cases you can just complicate your code just for the sake of reducing duplication without any real benefits.

OK! Next episode will be about “Primitive Obsession” which is extremely common in Ruby world.
