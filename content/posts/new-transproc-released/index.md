---
title: New Transproc Released
date: '2015-07-13'
categories:
- blog
tags:
- archives
- blog
- oss
- rom
- ruby
slug: new-transproc-released
aliases:
- "/2015/07/13/new-transproc-released"
- "/new-transproc-released"
---

[Transproc](https://github.com/solnic/transproc) is a small library I wrote a [couple of months back](/2015/04/16/introducing-transproc-functional-data-transformations-for-ruby.html). It’s been growing nicely and yesterday its 0.3.0 version was released which redefined how it works and what it really is. I’m exicited about this project as it’s been used in [ROM](https://github.com/rom-rb/rom) to implement its Mapper component and turned out to be very powerful and flexible while remaining simple.

In this post I’d like to show you what transproc really is and how it can be used with other libraries.

## New Way Of Importing Methods

Thanks to awesome work by [Andrew Kozin](https://github.com/nepalez) Transproc can now import methods from other modules and wrap it with a simple API allowing you to compose imported methods into a pipeline:

```generic
module Functions
  extend Transproc::Registry

  import Transproc::Coercions
  import Transproc::ArrayTransformations
  import Transproc::HashTransformations
end

def t(*args)
  Functions[*args]
end

t(:to_string)[1] # => "1"

t(:rename_keys, user_name: :name)[{ user_name: "Jane"}] # => {:name=>"Jane"}

t(:map_array, t(:to_integer))[["1", "2", "3"]] # => [1,2,3]

```

## Importing Methods From Any Module

Importing methods is _not limited_ to built-in transproc modules. You can import methods from any module that has singleton methods, like for example `inflecto` gem:

```generic
module Functions
  # ...

  # import all
  import Inflecto

  # you can cherry-pick and even rename too
  import :camelize, from: Inflecto, as: :camel_case
end

t(:tableize)["FooBar"] # => "foo_bars"

t(:camel_case)["foo_bar"] # => "fooBar"

```

This means you can define your own modules too:

```generic
module Serializers
  def self.from_json(input)
    JSON.parse(input)
  end
end

module Functions
  # ...

  import Serializers
end

t(:from_json)['[{"foo":"bar"}]'] # => [{"foo" => "bar"}]

```

## Composing Imported Methods

Imported methods can be composed together into a single tranformation pipeline:

```generic
transformation = t(:rename_keys, user_name: :name) >> t(:map_value, :age, t(:to_integer))

transformation[{ user_name: 'Jane', age: '21' }] # => {:age=>21, :name=>"Jane"}

```

As you can see composition works the same but the global `Transproc` function registry is deprecated and you can now define your own registries with `Transproc::Registry` extension. This solution is simpler and more flexible and removes the need for a single global registry which could result in name-conflicts.

## So, what’s Transproc?

It’s now clear that transproc has become a library for method composition via its first-class `Transproc::Function` API. Since now you can import methods from any module it is very likely you’ll manage to use transproc with other gems or your own modules.

Ability to import methods from any module and being able to provide arbitrary procs too makes it very flexible. You can easily encapsulate small transformation functions, test them in isolation and compose into a single complex transformation.

This approach is quite simple and consistent and doesn’t require any monkey-patching.

And it’s not just for transformations! Transproc already provides other functions like `:is` predicate or `:recursion`. You can check them out in the [API](http://www.rubydoc.info/gems/transproc) documentation.

## Plans for 1.0.0

We’re thinking about splitting transproc into smaller gems and probably establishing a separate organization on GitHub for it. Main `transproc` gem would provide core functionality with additional gems shipping specific methods like `transproc-array` or `transproc-coercions`. There’s still a lot of work pending to improve test coverage and of course deprecated APIs will be removed for 1.0.0 release, so please upgrade to 0.3.0 and get rid of any deprecation warnings that you see.
