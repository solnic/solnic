---
title: Part of DataMapper 2 Is Done - Announcing Virtus 0.5.0
date: '2012-06-10'
categories:
- blog
tags:
- archives
- blog
- datamapper
- ruby
slug: part-of-datamapper-2-is-done-announcing-virtus-050
aliases:
- "/2012/06/10/part-of-datamapper-2-is-done-announcing-virtus-050"
---

**UPDATE**: DataMapper 2 was renamed to Ruby Object Mapper (ROM). For more info check out [rom-rb.org](http://rom-rb.org/)

* * *

I’m happy to announce that [Virtus 0.5.0](https://rubygems.org/gems/virtus) was released. It’s sort of a milestone for me as Virtus is now considered feature-complete and I’m quite happy with the code. Further development will only focus on bug fixes and small internal clean ups. We plan to extract smaller pieces into separate gems at some point too. Specifically Coercion mechanism, DescendantsTracker and Equalizer will very likely become separate gems.

So, what’s new in 0.5.0?

## Using Virtus in Modules

The release brings support for using Virtus within modules. The feature was requested some time ago but I postponed the implementation until there was a bigger demand. I was a bit worried that supporting this will complicate the code too much but it turned out I was wrong :)

Using Virtus in modules is as easy as this:

```generic
module Publishable
  include Virtus

  attribute :title,      String
  attribute :author,     String
  attribute :publish_on, Date
end

class Article
  include Publishable
end

class Book
  include Publishable
end

book = Book.new(
  title: "Foo Bar", author: "John Doe", publish_on: Date.today)

article = Article.new(
  title: "Review of Foo Bar", author: "Jane Doe", publish_on: Date.today)

```

Thanks to this feature Representable gem, which now uses Virtus for coercions, can be used in both classes and modules. So enjoy it!

## Extending Objects “on the fly”

It is also possible now to dynamically extend objects and define attributes on them. Check this out:

```generic
class Book
end

book = Book.new
book.extend(Virtus).attribute(:title, String)
book.title = "DCI with Virtus for fun and profit"
book.title
# => "DCI with Virtus for fun and profit"
book.attributes = { title: "DCI with Virtus for fun and profit ver. 2.0" }
book.title
# => "DCI with Virtus for fun and profit ver. 2.0"

```

## Improved Embedded Value with support for Struct

That’s a small but beautiful addition - you can now use a Struct as an Embedded Value attribute type. Here’s a short example showing what I mean:

```generic
Point = Struct.new(:x, :y)

class Rectangle
  include Virtus

  attribute :top_left,     Point
  attribute :bottom_right, Point
end

rectangle = Rectangle.new(:top_left => [ 3, 5 ], :bottom_right => [ 8, 7 ])

rectangle.top_left.x # => 3
rectangle.top_left.y # => 5

rectangle.bottom_right.x # => 8
rectangle.bottom_right.y # => 7

```

You are not forced to use structs of course. You can use a custom class with a custom initialize method and it’s still going to work.

## What’s Next?

Virtus is one of the pieces of DataMapper 2, since it’s mostly done we can safely say that a significant part of DM2 is done too. I’m switching my focus to [dm-mapper](https://github.com/solnic/dm-mapper) now so expect more work there in the upcoming weeks.

If you haven’t done it yet - I encourage you to try out Virtus and tell me what you think. We want it to be rock solid for DataMapper 2 release!
