You can now support my Open Source work by
[becoming a GitHub Sponsor](https://github.com/sponsors/solnic)!

## About

I started contributing to Open Source projects in 2008 and over time I created, contributed to and helped **with over 100 libraries and frameworks**. This page lists the most notable of my contributions.

## Hanami

[Hanami](https://hanamirb.org) is a Ruby application framework with a modern component-based architecture. I've been part of the core team since 2018, working on its 2.0 release which uses various dry-rb libraries as its foundation as well as rom-rb as the default "model layer".

## dry-rb

The organization was created by [Andy Holland](https://github.com/AMHOL) in 2015. I was thinking about doing a similar thing so I decided to contribute and started working on a couple of gems under this organization. The projects aim to be a modern take on solving common problems. Libraries are small and simple to understand with a great focus on reusability.

My main contributions include:

- [dry-validation](https://github.com/dry-rb/dry-validation) - validation library with type-safe schemas and rules
- [dry-schema](https://github.com/dry-rb/dry-schema) - schema DSL that was originally provided by dry-validation
- [dry-types](https://github.com/dry-rb/dry-types) - a flexible "type system" for Ruby projects. Currently it's the foundation for other libraries, like rom-rb, dry-validation, hanami or reform
- [dry-struct](https://github.com/dry-rb/dry-struct) - a virtus-like attributes API for POROs
- [dry-logic](https://github.com/dry-rb/dry-logic) - composable rule objects
- [dry-system](https://github.com/dry-rb/dry-system) - a modern way of organizing Ruby applications using dependency injection as the architectural foundation
- [dry-auto\_inject](https://github.com/dry-rb/dry-auto_inject) - container-agnostic auto-injection abstraction
- [dry-events](https://github.com/dry-rb/dry-events) - a simple pub/sub solution
- [dry-monitor](https://github.com/dry-rb/dry-events) - a set of abstractions that help with application monitoring

Make sure to check out our [official website](http://dry-rb.org/)!

## rom-rb

The work on [Ruby Object Mapper (rom-rb)](http://rom-rb.org/) initially started as an attempt to build the second major version of the DataMapper project; however, in 2014 I [decided](https://solnic.codes/2014/10/23/ruby-object-mapper-reboot/) to take the project in a different direction and turn it into an FP/OO hybrid toolkit that simplifies working with the data using Ruby language. It consists of a small(ish) core and plenty of adapters and extensions.

My contributions include:

- [rom-core](https://github.com/rom-rb/rom/tree/master/core) - design and implementation of the core APIs, such as`ROM::Gateway`, `ROM::Relation`, `ROM::Command` or `ROM::Mapper`
- [rom-repository](https://github.com/rom-rb/rom/tree/master/repository) - design and implementation of the repository component
- [rom-changeset](https://github.com/rom-rb/rom/tree/master/changeset) - design and implementation of the changeset component

Apart from its main components, I've also created or contributed to:

- [rom-sql](https://github.com/rom-rb/rom-sql) - the official SQL adapter
- [rom-elasticsearch](https://github.com/rom-rb/rom-elasticsearch) - the official Elasticsearch adapter
- [rom-factory](https://github.com/rom-rb/rom-factory) - the official data generator and "factory" toolkit

Make sure to check out our [official website](http://rom-rb.org/)!

## Transproc

[Transproc](https://github.com/solnic/transproc) is a Ruby gem which provides an API for functional composition of arbitrary Proc-like objects. It introduced the left-to-right `>>` function composition operator, which is [now considered](https://bugs.ruby-lang.org/issues/6284) as a potential addition to Ruby's core.

The gem comes with a ton of built-in data transformation functions, which initially was its main purpose. It is used as the data transformation foundation in rom-rb.

## Past projects

These are the projects that I used to work in the past that are now discontinued.

### DataMapper

[DataMapper](https://github.com/datamapper) was a Ruby ORM that was part of the default stack of the Merb framework. I started helping with the project in late 2008 and eventually joined the core team in 2010. I mostly focused on working on the Property API (which later on was extracted into a separate library called Virtus), on-going maintenance, bug fixing, user support and handling releases.

### Virtus

[Virtus](https://github.com/solnic) is a project that started as an extraction of the DataMapper Property API back in 2011. Eventually it has become very popular and made typed struct-like objects in Ruby **a thing** and inspired people to build their own solutions too. There were also many other gems that started using Virtus under the hood for coercions, like Representable or Grape.

The project has been discontinued in 2019 because I shifted my focus on dry-rb which provides much better solutions to the same kind of problems that virtus tried to solve.

### Coercible

[Coercible](https://github.com/solnic/coercible) is the coercion backend extracted from Virtus which provides a set of generic coercions for most common data types like numbers, dates etc.
