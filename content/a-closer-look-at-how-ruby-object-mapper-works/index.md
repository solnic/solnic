---
title: A Closer Look at How Ruby Object Mapper Works
date: '2013-08-26'
categories:
- blog
tags:
- archives
- blog
- datamapper
- orm
- rom
- ruby
slug: a-closer-look-at-how-ruby-object-mapper-works
aliases:
- "/2013/08/26/a-closer-look-at-how-ruby-object-mapper-works"
---

Last Friday we finally [released](https://groups.google.com/forum/#!topic/rom-rb/tvx9PNj2ewE) the first version of [Ruby Object Mapper](http://rom-rb.org). It’s a big step for the project as we’ve established foundation of the whole system. There are many missing features, crucial ones, like support for RDBMS, server-side generated keys or a full-blown Unit of Work but…we’ll be adding those in the upcoming future releases. With the foundation in place it’ll be much easier for us to continue working on ROM so you should see frequent releases from now on with important additions.

People have been asking me many times how we are going to support different databases and still being able to leverage their native features. That’s a good question and I’d like to answer it by explaining how ROM is designed. This will hopefully give you an idea how things work.

## Overview

ROM stack consists of four main layers:

- Axiom relations
- Gateway proxies with adapters
- ROM relations & mappers
- ROM session with state tracking

Axiom with its gateways and adapters is already a very feature-rich and powerful layer on its own, however it works on a lower level using raw data structures (tuples) whereas ROM layer knows how to map tuples into ruby objects and provides interfaces that are more convenient to use than axiom’s. On top of ROM relations we have session with things like “dirty” tracking and interface for persisting entire object graphs that were loaded into memory. Unfortunately its most advanced feature, Unit of Work, is not implemented at this point.

## Axiom relations

ROM uses [Axiom](https://github.com/dkubb/axiom) library - a relational algebra (RA) abstraction that’s very powerful giving us ability to perform all RA operations in memory when a database backend doesn’t support them.

Here’s how an axiom relation may look like:

```generic
# here's an in-memory relation with data tuples
relation = Axiom::Relation.new(
  [[:id, Integer], [:name, String]],
  [[1, 'John'], [2, 'Jane']]
)

# now we can do lots of RA operations, like for example restrict and sort
user_tuple = relation.restrict(name: 'Jane').sort_by(:name).to_a.first

user_tuple # => [2, 'Jane']

# and here's a base relation named :users
relation = Axiom::Relation::Base.new(:users,
  [[:id, Integer], [:name, String]]
)

```

## Axiom adapters & gateways

Since we’re going to talk to various data sources we want to have adapters that will know how to do that. That’s why we introduced the concept of axiom adapters which internally use something we called gateways. Gateways are working as a proxy that can push certain calls down to the underlaying axiom relation or directly to the database depending on its capabilities. This may sound a bit complex but it really isn’t. Take a look at how we could implement a YAML adapter with a gateway:

```generic
class YamlAdapter
  def initialize(path)
    @data = YAML.load_file(path)
  end

  def read(relation)
    attributes = relation.header.map(&:name)
    @data[relation.name].map { |hash| hash.values_at(*attributes) }
  end
end

class YamlGateway < Axiom::Relation
  include Axiom::Relation::Proxy

  attr_reader :relation, :adapter

  def initialize(relation, adapter)
    @relation = relation
    @adapter  = adapter
  end

  def each(&block)
    tuples.each(&block)
  end

  private

  def tuples
    Relation.new(header, adapter.read(relation))
  end
end

```

This code is pretty straight-forward. A gateway will proxy all the unknown calls down to its axiom relation and it will use the adapter to read the actual data from a YAML file. Now if we had a database that could natively support a specific operation, like for example a join, we would simply override `join` method in the gateway class and provide implementation that would use native capabilities of our database. Reading data from a raw YAML file definitely doesn’t provide any RA operations that’s why everything is proxied to the axiom relation.

## ROM relations & mappers

ROM relations live in the next layer of the stack and they simply wrap axiom gateways. Since gateways know how to fetch data from the actual data sources through adapters and they quack just like axiom relations we can easily support all operations either in memory or via the database. A ROM relation also uses a mapper to load data returned by a gateway into ruby objects and to dump them back to a form digestible by the gateway.

There’s no dark magic involved here. Here’s how a ROM relation could work with our YAML gateway:

```generic
relation = Axiom::Relation::Base.new(:users, [[:id, Integer], [:name, String]])
adapter  = YamlAdapter.new('/tmp/sample.yaml')
gateway  = YamlGateway.new(relation, adapter)

# let's say our user model is a simple struct
User = Struct.new(:id, :name)

# ROM comes with its built-in mappers but for simple use cases implementing
# your own mapper could boil down to this
class UserMapper
  def load(tuple)
    User.new(*tuple.values_at(:id, :name))
  end

  def dump(object)
    [object.id, object.name]
  end
end

# building a ROM relation is easy
users = ROM::Relation.new(gateway, UserMapper.new)

# now we can work with ROM relation just like with an axiom one
# but the difference is that we're working with ruby objects now
jane = users.restrict(name: 'Jane').one

jane
# => #<struct User @id=2, @name="Jane">

```

As you can see you can inject your own mappers when setting up ROM relations although I suspect in most of the cases using ROM’s builtin mappers will be the most popular choice.

## ROM session with state tracking

ROM session exposes specialized ROM relations which are proxies using the same approach as gateway and axiom relations. CRUD methods are overridden and instead of immediately performing some operation it’s added to the execution queue. When you flush the session it will execute all the operations in the same order as they were added. The missing part right now is to add Unit of Work which will be an injectible object that will operate on the execution queue. The UoW object will sort the operations based on the dependencies between objects loaded into memory.

Once we get to implementing UoW for session I will definitely share more information. This will be a pretty neat piece of ROM.

## Summary

When you’re [defining schema](https://github.com/rom-rb/rom#1-set-up-environment-and-define-schema) all that happens under the hood is establishing axiom gateways. Then when you’re [defining mapping](https://github.com/rom-rb/rom#2-set-up-mapping) the gateways are being wrapped with ROM relations with injected mappers. In ROM environment you have access to both gateways providing “raw” database access and the mapped relations that load ruby objects. As I said, no dark magic is involved in the process.

I hope this is not too detailed and not too general at the same time and after reading this post you’ll understand how ROM works. I would love to know what you think. We’ll be working hard to add support for RDBMS and Unit of Work and in the meantime it would be fantastic to see people writing new adapters for Axiom. We still haven’t come up with a unified interface for adapters and gateways simply because there are not enough adapters built yet (we have 5 so far). Once we have more adapters we will identify common interface and create abstract adapter/gateway to make things even simpler. By the way it would be especially interesting to see adapters for Riak and CouchDB.

I encourage you to try out ROM today. You may find it useful already and if you don’t then come and help us adding more features and working towards 1.0.0 :)

You can check out working ROM examples in [rom-demo](https://github.com/solnic/rom-demo) repository.
