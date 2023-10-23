---
title: Introducing Transproc - functional data transformations for Ruby
date: '2015-04-16'
categories:
- blog
tags:
- archives
- blog
- data
- mapping
- oss
- rom
- ruby
slug: introducing-transproc-functional-data-transformations-for-ruby
aliases:
- "/2015/04/16/introducing-transproc-functional-data-transformations-for-ruby"
---

Data mapping, or how I prefer to call it - data transformations, is something I’ve tackled in a couple of projects already. First, in DataMapper ORM with its Property API. Then in Virtus, a project that started as an extraction of DataMapper Property API to a separate gem. Then Virtus evolved into something more powerful and quite a lot of people really enjoy using it until this day.

The approach used in Virtus and many other libraries similar to Virtus is typical OO design. There are some objects with knowledge about how to handle specific values. This includes data type coercions and also more complex transformations like changing nested Hash into an aggregate using custom entity classes.

And it sucks. It sucks because OO is horrible for processing data.

Recently I’ve read an interesting [blog post](http://blog.jessitron.com/2013/04/dataflow-in-ruby.html) by Jessica Kerr from **2013** where she says:

> I like to think of my code in terms of a pipeline for data, transforming and working it and summarizing it into information

I share this sentiment. It’s also the reason why [ROM](http://rom-rb.org) is so data-centric and less OO even though you do turn data into objects eventually. So, how does ROM do it? You may not know that but ROM doesn’t handle data transformations. Instead, it has an interface for plugging in data transformation backends and let me introduce the first one called [Transproc](https://github.com/solnic/transproc).

## Data transformation functions

The core concept in ROM is passing data through multiple objects, each returning new representation of the original input. Transproc is built in the same way and it has two functional properties:

- data transformation is handled by stateless “functions”
- “functions” are composable using left-to-right data passing

Keep in mind that I’m not pretending that I’m writing purely functional code in Ruby, it’s not really possible; however, I managed to come up with a simple implementation that allows function-like behavior even though we are using objects representing “functions”.

The reasoning for this approach is quite simple - it is essential to be able to easily capture every type of data transformation and encapsulate it in a function in a way that makes it easy to compose multiple transformations into a data pipeline. More idiomatic Ruby approach doesn’t work here so well. You either have horrible monkey-patches like `Hash#symbolize_keys` or you come up with a convoluted set of abstractions that lack simple composability and very quickly become too complex.

## Data pipeline

Data pipeline is a simple concept where data is being passed from one object to another. In both ROM and Transproc we use left-to-right pipelining. Which means that by composing `X` and `Y` the result from `X` is passed to `Y`.

The `>>` or `+` operators can be used to compose two functions. Here’s a simple example:

```generic
require 'transproc/hash'

fn = Transproc(:symbolize_keys) >> Transproc(:rename_keys, user_name: :name)

fn.call({ 'user_name' => 'Jane' })
# => { :name => 'Jane' }

```

What happens here is that you define 2-step data transformation function without the need to refer to the data object (a hash) itself. Compare that to a more idiomatic Ruby approach:

```generic
hash = { 'user_name' => 'Jane' }
hash.symbolize_keys.tap { |h| h[:name] = h.delete(:user_name) }
# => { :name => 'Jane' }

```

There are a couple of problems with this. First of all - a monkey-patch. Then manual hash mutation using the result from `symbolize_keys` method call. Symbolizing keys is straight-forward but then we need much more logic to accomplish our goal. If you wanted to encapsulate that logic you’d either have to add another monkey-patch or introduce a separate object to handle it which would add even more complexity. This is exactly why idiomatic OO Ruby approach for data transformation sucks.

## Custom transformations

Another nice property of Transproc is that it’s really easy to add your own transformation functions by simply providing a name and a proc. After doing that your function can be composed with the built-in ones. Take a look:

```generic
Transproc.register(:to_json, -> v { JSON.dump(v) })

Transproc(:to_json).call([{ name: 'Jane' }])
# => "[{"name":"Jane"}]"

# ...or create a module with custom transformations
module MyTransformations
  extend Transproc::Functions

  def load_json(v)
    JSON.load(v)
  end
end

(Transproc(:load_json) >> Transproc(:symbolize_keys)).call('[{"name":"Jane"}]')
# => [{ :name => "Jane" }]

```

## Try it!

I guess for many Rubyists what I’m showing in this article looks awkward. Please don’t feel discouraged and just give it a try. We’re adding more transformations with each version so if you see something is missing please [report it](https://github.com/solnic/transproc). Check out [the docs](http://www.rubydoc.info/gems/transproc) and have fun transforming data.
