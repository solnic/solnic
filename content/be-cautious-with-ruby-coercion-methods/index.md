---
title: Be cautious with Ruby coercion methods
date: '2020-07-29'
categories:
- blog
tags:
- archives
- coercion
- ruby
- validation
slug: be-cautious-with-ruby-coercion-methods
aliases:
- "/2020/07/29/be-cautious-with-ruby-coercion-methods"
---

Coercion is a tricky problem to solve and it's something we need pretty much everywhere. Whether you're building a web application or a CLI tool, you will have to coerce values in some way. I say it's a tricky problem because Ruby comes with many builtin coercion methods but it's not enough. Furthermore, the builtin methods may actually lead to bugs or surprising behaviors.

In this article we'll take a look at the builtin coercion methods, various caveats that come with their usage and ways how you can handle coercion in a more predictable and strict way.

## Instance coercion methods

Let's start with the most problematic type of coercion methods - instance coercion methods that start with `#to_*`. They feel very idiomatic and people use them quite often. That's why it is important to understand how they work because you may end up with results you did not expect. Another reason is to be sure that what you're doing is intentional.

Here's a list of various caveats that I'm sure many of you either didn't know about or you don't remember about them:

### Calling coercion methods on `nil`

I consider this to be a classic mistake in Ruby code. Here's how it can bite you:

```ruby
nil.to_i
# 0
nil.to_f
# 0.0
```

I know that instinctively you may think "this makes sense" - after all, `nil` represents "nothing", and in the realm of numbers `0` is "nothing". In a way, there's some reasoning behind this behavior. The problem is that **this can easily hide bugs** in your code.

Here's a typical scenario:

```ruby
def total_price(line_items)
  line_items.map { |line_item| line_item[:price].to_i }.reduce(:+)
end
```

Can you see the problem? Correct! If the `line_item[:price]` returns `nil` then the code will still work. The bug here is that it shouldn't be possible for the line item to have `nil` price, yet if that's what happened, this method will happily perform the calculation.

The solution is to already have the price represented as an integer. In such core domain methods there should be no place for coercions. However, if you're working with a legacy code base and you can't refactor it just yet, then I recommend using `Integer(line_item[:price])` instead. It's more intentional and it will raise an error in case of a value that cannot be coerced, including `nil`.

There are more caveats in case of `nil` and coercion methods. Remember about them:

1. `nil.to_h` => `{}`
2. `nil.to_a` => `[]`
3. `nil.to_f` => `0.0`
4. `nil.to_r` => `(0/1)`
5. `nil.to_c` => `(0+0i)`

### Accidental string => number coercions

Another caveat is that a string that starts with a number may be mistakenly coerced into a number. How? Here's how:

```ruby
"312".to_i
# 312

"312 oh hai".to_i
# 312
```

As you can probably imagine, this may easily lead to bugs where a completely unexpected value ends up being coerced into a number without anybody noticing it.

Same advice as before - use Kernel coercions instead.

### Handling of empty strings

This is a really weird one and I always wonder what the reasoning behind this behavior is. Using `#to_*` number coercions with an empty string actually returns zero (represented by different types of numbers). Here are a couple of common examples:

```ruby
"".to_i
# 0

"".to_f
# 0.0
```

### Array <=> Hash coercions

Beware that using `#to_a` and `#to_h` on empty hashes or arrays works and it can bite you. Look:

```ruby
[].to_h
# {}

{}.to_a
# []
```

This works because it is possible to convert Array<=>Hash only **when an array is a list of key/value pairs**. The problem is that if you're blindly coercing a bunch of values into, let's say, hashes, and you don't check anywhere that each value is a key/value pair, then you may get unexpected results.

This one's a bit messy because even with Kernel coercions the behavior feels inconsistent:

```ruby
Array({})
# []

Array({a:1})
# [[:a, 1]]

Hash([])
# TypeError (can't convert Array into Hash)

Hash([[:a, 1]])
# TypeError (can't convert Array into Hash)
```

In case of complex data structures it's better to properly validate the input, check types and structure of individual values, before coercing anything.

## Kernel coercion methods

A much stricter way of coercing values in Ruby is to use Kernel coercion methods, like it's mentioned above you can use them to avoid various common caveats.

Here's what's available:

1. `Integer`
2. `Float`
3. `String`
4. `Array`
5. `Hash`
6. `BigDecimal`
7. `Rational`
8. `Complex`

There is **a big difference** between kernel coercion methods and `#to_*` instance methods - kernel coercions **raise TypeError** in case of a value that cannot be coerced. This makes them much stricter and a better fit in case of domain logic.

Furthermore, number coercions do not coerce `nil` - which is something **that you typically want to avoid.** Here's an example with integers:

```ruby
Integer(nil)
# TypeError (can't convert nil into Integer)

Float(nil)
# TypeError (can't convert nil into Float))
```

## Libraries to the rescue

Despite the fact that Kernel coercions are stricter and safer to use in general, it won't solve the coercion problem!

Given the complexity of coercions and various "gotchas", I recommend using dedicated libraries that can be used to handle type conversion more safely. Long time ago I wrote [virtus](https://github.com/solnic/virtus) to help with this, eventually I created [dry-types](https://github.com/dry-rb/dry-types) that is a far better solution if you need coercions. One of the biggest issues with virtus was that it was based on the idea of "generic coercions" - this means that its coercion mechanism would accept \*a lot of different value types\* causing not only performance issues but also ambiguity. When dealing with coercions you want to be as intentional and explicit as possible.

_If you treat an empty string and nil the same way, it's not duck-typing - it's writing code that's prone to bugs and security issues._

There are plenty of ruby gems that can help you with coercions - check out results on [ruby-toolbox.com](https://www.ruby-toolbox.com/search?q=coercion) and pick up whatever works best for you.

It's also worth to mention that coercion should be typically handled along with validation. In a perfect-world scenario you want to validate that an input _can be coerced_, then coerce it and validate that the output _meets requirements and is valid_. That's a topic for another article.

Let me know what you think. Do you have similar experience? Do you know more caveats related to coercions? I'd love to know them!
