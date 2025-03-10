---
title: Introducing Yesql for Ruby using ROM
date: '2015-03-02'
categories:
- blog
tags:
- archives
- blog
- oss
- rom
- ruby
- sql
slug: introducing-yesql-for-ruby-using-rom
aliases:
- "/2015/03/02/introducing-yesql-for-ruby-using-rom"
- "/introducing-yesql-for-ruby-using-rom"
---

Last week we released a new beta version of ROM and you’ll be able to read more about it on [the official blog](http://rom-rb.org/blog) later this week. Today I’d like to tell you a little bit about a new adapter that I built for ROM that’s based on Yesql from the Clojure world.

When I was working on ROM I was paying attention to other languages too searching for inspiration and Yesql was one of my favorite discoveries. I loved the idea because it’s just-so-simple. We don’t like to write SQL but sometimes it’s the best option we have. Hiding SQL behind OO interfaces has its limitations. The more complex query you need to build the harder it becomes if you want to stick to some OO abstractions.

Here’s a real world example - currently at work we have a bunch of report queries. They are really complex and yet that’s actually the simplest way to get the data we need. Using ActiveRecord or hand-crafted ARel relations would be more complex than writing an SQL query.

A month ago I realized that with the way ROM works it should be really easy to build an adapter that has functionality similar to Yesql and so [rom-yesql](https://github.com/rom-rb/rom-yesql) was born.

## It’s all about the data

ROM isn’t an ORM, we’re probably going to spend a fair amount of time explaining that. ROM is a library that helps you to work efficiently with the data regardless of its source. Sure, it has features that allow you to create, update and delete data too but still - it’s not an ORM.

One of the ideas behind most ORMs, especially in the ruby ecosystem, is that an ORM maps data to mutable objects that can be changed and persisted back in the database. ROM is not like that, it separates reading from writing and it’s relation layer is really well suited for reading, transforming and _decorating_ data structures, whereas its command layer is designed to handle create, update and delete operations.

Because of this separation it’s really easy to plug-in any backend we want and _it will just work_.

Once you realize that your application first and foremost needs the data you may start to see that in many use cases a simple data-access is all that you want to do without the whole ORM ceremony.

In ROM a relation object can be as simple as this:

```generic
users = ROM::Relation.new([{ name: 'Jane' }, { name: 'Joe' }])

```

On top of this API additional functionality is implemented, any object that responds to `each` and yields other objects can be used as a data source in a relation.

## What about the behavior?

In an OO language like Ruby raw data structures are difficult to use that’s why we create our own objects with some functionality aka behavior that use data to do their job. When you use ActiveRecord you practically have a blend of data and behavior which quite often becomes problematic.

An alternative to this is separating data from behavior and simple decoration works really well here. I believe this is close to the ideas behind DCI and I found ROM to be very useful to be used like that.

ROM gives you a simple infrastructure to easily load data and optionally decorate them, this process may involve pretty complex data transformations if it’s required but a common usecase is really simple, just get the data and pass it to object’s constructor.

Under the hood all that ROM is doing is passing data from one object to another. You can just use a proc to load custom objects from a relation:

```generic
User = Struct.new(:name)

mapper = proc { |relation|
  relation.to_a.map { |tuple| User.new(tuple[:name]) }
}

users = ROM::Relation.new([{ name: 'Jane' }, { name: 'Joe' }])

mapper[users].inspect
# => [#<struct User name="Jane">, #<struct User name="Joe">]

```

As you can probably imagine you can pass those objects through multiple mappers which makes it very easy to load, transform and map data. ROM higher-level interfaces make that less verbose but they don’t add any additional complexity - it still boils down to sending data through a functional pipeline.

This is the core of ROM, really. On top of that various adapters are implemented and rom-yesql is now one of them.

## Plain old SQL and rom-yesql

It’s hard to say if it’d be feasible to build an entire application using just raw, hand-written SQL statements stored in the filesystem but there are definitely good use cases to use this approach.

I added a couple of features to rom-yesql to make it more flexible, for instance you can configure the adapter and pass queries as a hash:

```generic
ROM.setup(:yesql, [
  'sqlite::memory',
  queries: { users: { all: 'SELECT * FROM users' } }
])

class Users < ROM::Relation[:yesql]
end

rom = ROM.finalize.env

# now you can access users relation just like any other relation in ROM
users = rom.relation(:users)

puts users.all.to_a.inspect
# [{:id=>1, :name=>"Jane"}, {:id=>2, :name=>"Joe"}, {:id=>3, :name=>"Jade"}]

```

You can define ROM mappers too and map to custom objects if you want:

```generic
ROM.setup(:yesql, [
  'sqlite::memory',
  queries: { users: { all: 'SELECT * FROM users' } }
])

class Users < ROM::Relation[:yesql]
end

class User
  attr_reader :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
  end
end

class UserEntityMapper < ROM::Mapper
  relation :users
  model User
end

rom = ROM.finalize.env

# now you can access users relation just like any other relation in ROM
users = rom.relation(:users).as(:users)

puts users.all.to_a.inspect
# => [#<User:0x007ff89194cd48 @name="Jane">, #<User:0x007ff89194ccd0 @name="Joe">, #<User:0x007ff89194cc58 @name="Jade">]

```

If your queries needs some custom preprocessing you can also set a custom `query_proc` that is always used to evaluate a query. This makes it pretty flexible.

Your queries can be organized and stored as files grouped by relation dataset name, in example if you have `my_queries/users` then you can define `Users` relation or call it differently and set its `dataset` to `:users` and all queries from that directory will be loaded into your relation class.

I’m already using rom-yesql at work. Please try it out and tell me what you think. There are missing features like an ability to define multiple queries in one file but those can be added easily.

Check out [rom-yesql](https://github.com/rom-rb/rom-yesql) on Github and its (short) [documentation](http://www.rubydoc.info/gems/rom-yesql) - I hope you’ll find this useful.
