---
title: Ruby DataMapper Status
date: '2012-01-10'
categories:
- blog
tags:
- archives
- blog
- datamapper
- orm
- patterns
- ruby
slug: ruby-datamapper-status
aliases:
- "/2012/01/10/ruby-datamapper-status"
- "/ruby-datamapper-status"
---

**UPDATE**: DataMapper 2 was renamed to Ruby Object Mapper (ROM). For more info check out [rom-rb.org](http://rom-rb.org/)

* * *

In my recent post I gave you a brief overview of what I think about [the state of Ruby ORMs](http://solnic.codes/2011/11/29/the-state-of-ruby-orm.html). Since I’m involved in the development of [DataMapper](http://datamapper.org) project I want to write a little more lines of text to give you a good overview of the current state of DataMapper project and how the future version 2.0 is going to look like.

## DataMapper 1.x

Let’s get this straight once and for all: DataMapper was never a pure implementation of the Data Mapper pattern. It has elements of both Data Mapper and Active Record patterns. It has a mapping layer where you can configure mappings between model properties and database columns but this doesn’t change the fact that your models have direct access to the persistence layer and a lot of persistence-related functionality is mixed into them. This is what makes DataMapper an ‘ActiveRecord-ish’ library. After a few years of development it’s become clear that this approach, despite its advantages over ActiveRecord, is still not good enough.

Probably one of the biggest wins of DataMapper is support for many different kinds of data stores. Apart from supporting most common RDBMS databases there are adapters for various key-value stores, NoSQL databases and more. The flip side is that working with multiple data stores at once is not very stable at the moment and that you can’t easily use the full power of various databases, like MongoDB, due to limitations in DataMapper’s API.

The good news is that while working on DataMapper and many of its adapters we’ve learned our lessons. With all that knowledge and experience the work on DataMapper 2.0 has been started.

## DataMapper 2.0

First of all the next major version of DataMapper will implement the Data Mapper pattern as described in the PoEAA:

> A layer of Mappers that moves data between objects and a database while keeping them independent of each other and the mapper itself.
>
> **Martin Fowler** [martinfowler.com/eaaCatalog/…](//martinfowler.com/eaaCatalog/dataMapper.html’)

DataMapper 2 won’t be a big monolithic library, it will consist of multiple independent pieces that are glued together. Each piece of DM2 is a standalone library so that you could use it separately from the DM itself.

Let me describe all the related projects.

### Veritas - the new relational algebra engine

The core of DM2 is [Veritas](https://github.com/dkubb/veritas) - the new relational algebra engine developed by Dan Kubb. Why not ARel? The answer is simple - ARel is designed to generate SQL whereas DataMapper needs something more abstract with adapters that can handle different kinds of query dialects. With that premise Veritas is a full-featured relational algebra implementation and there’s already an [SQL generator](https://github.com/dkubb/veritas-sql-generator) which can build pretty complex queries. More generators will be written soon.

Here’s a quick sneak-preview of how you can build relations with Veritas:

```generic
header_one = [
  [ :id,   Integer ],
  [ :name, String ]
]

header_two = [
  [ :id,      Integer ],
  [ :user_id, Integer ],
  [ :name,    String ]
]

tuples_one = [
  [ 1, "john" ],
  [ 2, "jane" ]
]

tuples_two = [
  [ 1, 1, "john’s project" ],
  [ 2, 2, "jane’s project" ]
]

# build base relations
relation_one = Veritas::Relation::Base.new(‘one’, header_one, tuples_one)
relation_two = Veritas::Relation::Base.new(‘two’, header_two, tuples_two)

# rename conflicting attributes
relation_two = relation_two.rename(:id => :project_id, :name => :project_name)

# join the two relations on id == user_id
new_relation = relation_one.join(relation_two) { |r| r.id.eq(r.user_id) }

```

What’s great about Veritas is that with its level of abstraction you can use it for various things - not just to generate queries. For example there’s an idea of using Veritas to build a new “migrations” library for DM2 that will easily handle even very complex scenarios.

### Virtus - the new model definition and introspection layer

I’ve already introduced [Virtus](http://solnic.codes/2011/06/06/virtus-attributes-for-your-plain-ruby-objects.html) - it’s an extraction of DataMapper’s Property API. During the last few months we’ve made many significant improvements and more features will be added soon too. Virtus already supports defining attributes on your models and can handle many kinds of coercions. You can also implement your own coersion methods if you need them. In the near future Virtus will be supporting more complex functionality like [EmbeddedValue](http://martinfowler.com/eaaCatalog/embeddedValue.html) and [ValueObject](http://martinfowler.com/eaaCatalog/valueObject.html). It’s also possible that with Virtus you will be able to define relationships between POROs.

The important thing about Virtus is that it’s designed to work with PORO and it has nothing to do with any persistence concerns. For example there were people asking me about things like support for dirty attributes tracking - it’s not going to be included in Virtus.

I should mention that _DataMapper 2.0 will be designed to work with POROs_ that _are not_ extended by Virtus. Virtus will be optional but since it provides a very common functionality I suspect most people will want to use it.

### Aequitas - the new validation library

Developed by Emmanuel Gomez, [Aequitas](https://github.com/emmanuel/aequitas) is designed to work with any Ruby object and it also has support for Virtus. The idea is similar to what we have in DataMapper 1.x where validations can be derived from property declarations. Aquitas is based on the current [dm-validations](https://github.com/datamapper/dm-validations) and the API is very similar, if not identical. Aequitas has support for custom error messages, I18n, validation contexts and built-in data types which come with their own set of validation rules.

```generic
require ‘virtus’
require ‘aequitas/virtus_integration’

class Book
  include Virtus
  include Aequitas

  attribute :title,        String, :required => true
  attribute :published_at, Date
end

book = Book.new(:published_at => ”)

book.valid? # => false
book.errors[:title] # => [ "can’t be blank" ]"
book.errors[:published_at] # => [ "must be a date" ]

```

### Session, Dirty Tracking and Unit of Work

In the Data Mapper world every change made to the models loaded into memory is tracked by a specialized object which works like a session. When you’re done with making changes you can either commit them or rollback. The important thing is that all the complex logic behind tracking what was changed, what was deleted and what was added is handled by the session object. Your models are dumb in this regard, they don’t care about dirty tracking, it’s not their responsibility. It’s one of the major differences between AR and DM.

The session object will be an implementation of the Unit of Work pattern described in PoEAA as:

> Maintains a list of objects affected by a business transaction and coordinates
> the writing out of changes and the resolution of concurrency problems.
>
> **Martin Fowler** [martinfowler.com/eaaCatalog/…](//martinfowler.com/eaaCatalog/unitOfWork.html’)

More technically speaking a session will hold a [DAG](http://en.wikipedia.org/wiki/Directed_acyclic_graph) of commands sorted by their dependencies so that when you commit the session it will know in what order those commands should be executed.

When you think about it you will realize that this pattern is quite common. That’s why it would probably make sense to come up with a general UoW library and then create an extended version for DataMapper needs.

Here’s an example of how such a session _may_ look like:

```generic
DataMapper::Session.start do |session|
  user = User.mapper.get(1)
  user.name = ‘John’

  if user.valid?
    session.commit
  else
    session.rollback
  end
end

```

### The Mapper

Probably [dm-core](https://github.com/datamapper/dm-core), the current core DataMapper library, will be completely rewritten and become the mapper layer with a thin query API that delegates most of the heavy work down to a veritas adapter. For your convenience there will be a veritas mapper class that you can inherit from but this doesn’t mean that you won’t be able to write custom mapper classes. The idea is really simple here, a mapper class defines mappings between PORO and the database schema. In most of the cases this means a direct 1:1 mapping but the huge advantage is that once you need something custom - you will be able to define it.

This is really the key aspect of using a data mapper library - you define your domain objects so that they correspond to your real world domain as close as possible. It makes applying practices like [“Fast Rails Tests”](http://confreaks.net/videos/641-gogaruco2011-fast-rails-tests) suggested by Corey Haines come in a natural way because you’ll be implementing the business logic in POROs and have them unit tested in an isolation without the database access.

You will be able to define a mapper class more or less like this:

```generic
class User
  include Virtus

  attribute :id,            IdentityField
  attribute :email,         String
  attribute :name,          String
  attribute :birthday_year, Integer
end

class User::Mapper < VeritasMapper

  # default 1:1 mapping
  map :id

  # custom field name
  map :email => :email_address

  # map to 2 fields
  map :name => [ :first_name, :last_name ]

  # map to a result of a function call
  map :birthday_year => :birthday_date, :function => :date

end

```

## Roadmap? ETA?

There’s a work-in-progress roadmap for DM2 available [here](https://github.com/datamapper/dm-core/wiki/Roadmap). Regarding ETA it’s really hard to say. We’re taking our time to build all these libraries, there’s a big focus on code quality and proper test _and_ docs coverage. Once the roadmap is finalized we will be able to come up with some ETA.

Here’s the full list of related projects on [Github](https://github.com):

- [veritas](https://github.com/dkubb/veritas) - core library
- [veritas-sql-generator](https://github.com/dkubb/veritas-sql-generator) - SQL generator
- [veritas-do-adapter](https://github.com/dkubb/veritas-do-adapter) - DataObjects adapter
- [veritas-optimizer](https://github.com/dkubb/veritas-optimizer) - relation optimizer
- [virtus](https://github.com/solnic/virtus) - attributes/coercions
- [aequitas](https://github.com/emmanuel/aequitas) - validations

…and more will come soon, so stay tuned!

Make sure to follow [@datamapper](http://twitter.com/datamapper) on twitter too :)

If you’re eager to learn more you can always join #datamapper IRC channel. I also understand that this post doesn’t answer many possible questions - feel free to ask them in the comments.
