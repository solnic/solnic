---
title: Invalid Object Is An Anti-Pattern
date: '2015-12-28'
categories:
- blog
tags:
- archives
- activerecord
- blog
- data
- ruby
- type-safety
- validation
slug: invalid-object-is-an-anti-pattern
aliases:
- "/2015/12/28/invalid-object-is-an-anti-pattern"
---

The idea of an object that validates its own state has been made very popular by Rails’ ActiveRecord. We can see this pattern in many places, not only in ORM libraries but in many other gems whenever some sort of validation is needed.

Have you ever thought about _why_ we’re allowing invalid state just to…validate data? It doesn’t seem to be a good idea, in fact, it feels like a huge anti-pattern.

Let’s think about this for a second. Why do we validate data? Typically, to make sure that invalid state doesn’t leak into our systems. If it’s so essential to make sure that invalid state is not allowed then…why do we allow instantiating objects with invalid state? Especially when we’re dealing with such core objects like an Active Record model which deals with so called business logic. This sounds like a really bad idea.

When it’s possible to instantiate an invalid object, chances are it’s going to happen when you don’t really expect it.

Consider this:

```ruby
class User < ActiveRecord::Base
  validates :email, :name, presence: true
end

user = User.select(:id).first

```

We state that a user must have an email and a name but then it’s possible to create its instance by projecting only `:id` attribute. When something is possible, it means it’s going to happen. Especially in big code bases. ActiveRecord is at least kind enough to raise a meaningful error when you try to access an attribute that was not loaded from the database.

This kind of errors are probably not very common, since in most of the cases you rely on default behavior which is to load all attributes, but the fact that it’s possible to load an object into memory that in some contexts could crash your app feels like a bad strategy.

Using same objects as your “wall of defense” against untrusted input _and_ for implementing core application logic is a mistake. Since these objects accept invalid state, their lack of type safety makes them a shaky foundation for building complex systems. You can’t treat them as values as they are mutable. You can’t really rely on their state, because it _can be invalid_. You can’t treat them as canonical sources of information as their state depends on the query logic which _can be dynamic_ as the example above shows.

You may think that validations help here. You are almost right. Validations reduce the risk that your system will crash due to invalid state but they are no guarantee. Not to mention that in complex domains validation logic is just damn difficult to implement and despite your great efforts your database is being filled with invalid data. At some point you will see it once some new feature was added that happens to rely on that data but now you need to fix the data that you already have persisted, and often it is a troublesome process.

Type safety is important. Properly validating data at the boundaries of our system is one thing, making sure that core, foundational objects _are always valid_ is another thing. Which has inspired me to create dry-data and dry-validation.

## Type Safety Using dry-data and dry-validation

With [dry-data](https://github.com/dry-rb/dry-data) and [dry-validation](https://github.com/dry-rb/dry-validation) it’s possible to implement precise validation of an untrusted input _and_ define “domain objects” with constrained types, which is probably a unique and “unpopular” approach. Both libraries are using each other, which is a cool synergy - dry-validation uses coercion system from dry-types and dry-data uses predicates from dry-validation for constrained types.

UPDATE: yes, circular deps are not a good idea; dry-validation depends on dry-data but not the other way around. The common part used by dry-data, the rule/predicate system, will be extracted soon into a shared gem.

Here’s an example of our `User` model using dry-data struct with constrained types:

```ruby
module Types
  Email = Strict::String.constrained(format: /A[w+-.]+@[a-zd-]+(.[a-z]+)*.[a-z]+z/i)
  Name = Strict::String.constrained(size: 3..64)
end

class User < Dry::Data::Struct
  attribute :id, Types::Int
  attribute :email, Types::Email
  attribute :name, Types::Name
end

# this will raise a type error since name is too short
User.new(id: 1, email: 'jane@doe.org', name: 'J')
```

I’ve already benefited from simple type checks like checking if a given value has correct class, which helped me to spot silly bugs before an app hit the production. Now with dry-data + dry-validation it’s possible to be even more strict and define constrained types.

Both libraries are very young but I encourage you to try them out. I believe it’s going to help in building more robust applications. If you’re worried about performance check out [this gist](http://gist.github.com/solnic/58fade416fe80cf18df9) which shows how [ROM](https://github.com/rom-rb/rom) loads 3 type-safe user entities _slightly faster_ than non-type-safe ActiveRecord models.

If you are interested in dry-validation, check out my [previous post](/2015/12/07/introducing-dry-validation.html) and for more information about dry-data please refer to its [README](https://github.com/dry-rb/dry-data).
