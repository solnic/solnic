---
title: Duck typing vs type safety in Ruby
date: '2016-11-02'
categories:
- blog
tags:
- archives
- blog
- duck-typing
- ruby
- type-safety
- validation
slug: duck-typing-vs-type-safety-in-ruby
aliases:
- "/2016/11/02/duck-typing-vs-type-safety-in-ruby"
---

Duck typing is one of the virtues of the Ruby language, it adds a lot of flexibility to the code, and allows us to use objects of different type in places where only specific methods are needed. Even though the idea behind duck typing may seem to be straight-forward, it is easy to use it incorrectly. It’s interesting to notice that over many years we’ve adopted various techniques that _seem_ to leverage duck typing, but the specifics of how exactly we’re doing it are actually questionable, and I believe they deserve some reconsideration. This is directly related to the other important subject - type safety, and in this article I’d like to explain why we should care about it, while keeping duck typing in mind, too.

## The problem with blank? method

Using `blank?` method, typically provided by ActiveSupport, is extremely common in Ruby/Rails applications. People think it’s a good example of duck typing - we rely on this single method, so we don’t care if it’s an array, string or nil.

Here’s a different way to think about it - the fact we have this method _is a problem_, as it can easily cause unexpected values to sneak into our system, and it also leads to additional complexity that is completely unnecessary.

Consider this common pattern:

```generic
def process(collection)
  unless collection.blank?
    collection.map { |element| … }
  end
end

```

We want to map a collection, but it could be…what? An empty array? An empty string? Why is it even possible that this method can receive an empty string? This is the type of questions that are worth asking.

The _only_ reason why such conditionals are needed is that we don’t handle data at the boundaries of our system explicitly. This means we’re happily passing in _something_ right into the core of our system, and then “protect” ourselves by adding a bunch of conditionals to various places, so that our system won’t crash.

This is how this method should look like instead:

```generic
def process(collection)
  collection.map { |element| … }
end

```

The `blank?` method has a symbolic meaning here - it shows that instead of solving the root problem, by handling input data explicitly in a type-safe manner, we’ve chosen to complicate our code with monkey-patches and extra conditionals.

Without the extra `blank?` check, we still rely on duck-typing. Notice that the collection can be anything that responds to `map`. Furthermore, its elements will also be handled via duck-typing. You may start with a simple array, and later on change it to a custom enumerable object with `map` yielding compatible, duck-typed elements, and you’re all good.

## Type safety

Ruby with its duck typing may create an impression that type safety is not needed, or even that type safety is against duck typing. This is most certainly not true.

One of the reasons of rapidly growing complexity and potential security problems is the lack of type safety at the boundaries, like HTTP params. Any external system which provides data to our applications should be treated with special care.

Type safety in Ruby means that we want to make sure that the structure of the input data, as well as specific values in that structure, are valid in terms of basic constraints. Furthermore, type safety goes hand in hand with object coercions. You can easily reduce complexity of your application by making sure that specific values are properly coerced into types that are simple to work with.

Let’s go back to the trivial `process` method example. Imagine our system receives params as JSON, and one of the fields is called `”collection"` that _we expect_ to be an array. How do you express this expectation?

You can either write custom code or just use a dedicated tool, like dry-validation:

```generic
Schema = Dry::Validation.JSON do
  required(:collection).value(:array?)
end

params = { collection: %w(foo bar baz) }
result = Schema.(params)

process(result[:collection]) if result.success?

```

This way you establish an explicit _contract_ between the outer layer of your system which deals with http params, and your core application layer, which says “my system will process params only when `collection` key is present and its value is an array”; but this is obviously a trivial case, let’s make it more complex.

What if our requirement is that it must be an array, with minimum 3 elements, and each element must be a string with minimum 2 characters? Imagine how your code would look like if you wanted to add guarding clauses for all these requirements (hint: it would be awful). Because handling such constraints manually leads to a lot of additional complexity, we tend to either do it only partially (ie by not checking everything, which results in less robust code) or just skip it altogether assuming that “it’s gonna be fine” (and it rarely is).

With a dedicated gem like dry-validation this type of constraints are easy to express:

```generic
Schema = Dry::Validation.JSON {
  required(:collection) {
    array? & min_size?(3) & each(:str?, min_size?: 2)
  }
}

Schema.(collection: "").errors
# {:collection=>["must be an array"]}

Schema.(collection: ['foo', 'bar']).errors
# {:collection=>["size cannot be less than 3"]}

Schema.(collection: %w(foo bar b)).errors
# {:collection=>{2=>["size cannot be less than 2"]}}

Schema.(collection: ['foo', 'bar', 1]).errors
# {:collection=>{2=>["must be a string"]}}

Schema.(collection: %w(foo bar baz)).errors
# {}

```

You may get an impression that this is now more complicated, but in reality it’s the exact opposite. Most bugs are caused by unexpected or invalid values that are leaking into places of your system where it doesn’t know how to handle them properly, so it crashes. You start fixing bugs by adding more and more conditionals, and in case of Rails and many Ruby apps, you use monkey-patches like `present?` or `blank?`, which sort-of expresses what the contracts are, but it’s _vague, incomplete and implicit_; and most importantly it does not guarantee that the core of your system receives valid input exclusively.

## Summary

Handling data in a type-safe manner is a technique that makes your applications simpler and more robust. Even though it requires additional gems, as the problem domain is complex enough to justify extra libraries, you need data validation _anyway_, and you most likely already use a gem which provides that (ie ActiveModel). Regardless of the tools you decide to use, I encourage you to think about type safety when you’re building a Ruby application, and validate data at the boundaries of your system. It’s not against duck-typing, you could even say it’s a complementary concept, as through type safety you can perform all kinds of coercions to adjust input data in a way that will make your system simpler and leverage duck-typing at the same time.

There’s _much more to say about duck typing_ though, but I’m leaving that for another article.
