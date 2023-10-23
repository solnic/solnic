---
title: DataMapper 2 Status and Roadmap
date: '2012-12-20'
categories:
- blog
tags:
- archives
- blog
- datamapper
- ruby
slug: datamapper-2-status-and-roadmap
aliases:
- "/2012/12/20/datamapper-2-status-and-roadmap"
---

<div class="well" **UPDATE**: This article is outdated. DataMapper 2 was renamed to Ruby Object Mapper (ROM). For more info check out [rom-rb.org](http://rom-rb.org/).

We’ve been really busy working on the mapper part of DataMapper 2 for the last few months. This gives us more clarity about what is still missing. The mapper currently supports two different engines, Veritas and Arel. By introducing engines API we managed to create a nice database abstraction layer along with model and attribute mapping layers. The entire system works like a multi-level pipe so that we have 3 separate “levels” where data is being processed. Data fetched by a database driver is consumed by a gateway which sends data up to the mapping layer. The mapping part is pretty much done and powerful. We can map “raw” data sets to domain objects. We can map relationships by eagerly loading them from a database. We can map embedded values and collections too. This is pretty awesome already :) OK so what’s still missing?

## Veritas “write” Support

Currently our veritas engine supports only reading from the databases. Dan Kubb will be working on finishing write support in Veritas and once that’s done we’ll be able to easily integrate it with dm-mapper. Veritas will also be renamed soon as people are confusing it with Virtus.

## Arel Engine Using DataObjects

One of the things I want to tackle is to extract connection handling from ActiveRecord and port it to use DataObjects to achieve consistent behavior across all the drivers. Currently dm-mapper uses anonymous ActiveRecord::Base subclasses just to make it work with Arel. This was always a temporary solution and now it’s time to improve it. I believe this could become a win-win situation for both DataMapper and ActiveRecord projects if we could use the same drivers. I’m not sure if rails-core team would be interested in working on it though.

## Coercions For Engines

I will soon extract [Virtus::Coercion](https://github.com/solnic/virtus/tree/master/lib/virtus/coercion) into a separate project and use it in dm-mapper so that engines could perform data coercions when a database driver doesn’t support it. This also requires a bigger addition to the dm-mapper where we will be able to define how certain ruby types are being coerced into values in a database. For example casting true object to “1” or date time to time etc.

## Session Integration

We have already a working persistence state-machine that now we need to integrate with dm-mapper. The concept is pretty simple. The mapper provides database access API and if you need things like “dirty tracking” or dependency resolution via UnitOfWork then you use a special session object that extends mapper API.

## How is it going to look like?

Lots of things already work so here’s a short sample of how the API looks at the moment:

```generic
# In DataMapper 2 we don't pollute global constants with shared state.
# That's why we decided to use an environment object that *you*
# create and use do build mappers and configure everything.

# Let's call it "datamapper" :)

datamapper = DataMapper::Environment.new

# You use environment object to establish connection with a db
datamapper.setup :postgres, :uri =&gt; "postgres://localhost/test"

# So let's say we have 2 domain objects Page and Book

class Page
  include DataMapper::Model

  attribute :id, Integer
  attribute :content, String
end

class Book
  include DataMapper::Model

  attribute :isbn, String
  attribute :title, String
  attribute :author, String
  attribute :pages, Array[Page]
end

# You use environment object to build mappers

datamapper.build(Page, :postgres) do
  key(:id)
end

datamapper.build(Book, :postgres) do
  key(:isbn)

  # here we establish a relationship between page and books
  has 0..n, :pages, Page
end

# we need to finalize the env now
datamapper.finalize

# to access a mapper you use #[] method and model constant
# so to fetch all books with their pages you just do:

datamapper[Book].include(:pages).all

# Query API is pretty similar to what you already know

datamapper[Book].find(:author => 'John Doe').limit(10).offset(2)

```

Keep in mind that by integrating DataMapper 2 with various frameworks we will simplify a lot of the things. We’ll be able to generate mappers for you, call finalize automatically etc.

## Release Plan?

We want to push the first alpha as soon as we get all types of “primitive” coercions working. If I manage to port Arel to use DataObjects then this problem will be solved for rdbms databases and it’s going to be a good moment to push the first alpha. Maybe we’ll make it before end of the year ;P

After that we’ll continue with releasing next alpha versions until we’re certain that the foundation is solid and we can start the beta phase. Somewhere during that process Dan should be able to finish Veritas “write” support and we’ll start working on even more advanced things like cross-database interactions.

We need to go through lots of alpha/beta releases until we can tag 2.0.0 - after all it’s a completely new project.

## Related Projects

DataMapper 2 is a pretty big ecosystem of various gems that we like extracting from core parts whenever we feel it makes sense. Here’s a list of all the extracted gems:

- [Adamantium (helps in building immutable objects)](https://github.com/dkubb/adamantium)
- [IceNine (deep freezing objects)](https://github.com/dkubb/ice_nine)
- [Equalizer (builds equality methods for you)](https://github.com/dkubb/equalizer)
- [DescendantsTracker](https://github.com/dkubb/descendants_tracker)

And here are the core parts we’re working on:

- [Mapper](https://github.com/datamapper/dm-mapper)
- [Session and UoW](https://github.com/datamapper/dm-session)

* * *
