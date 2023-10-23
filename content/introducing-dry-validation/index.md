---
title: Introducing dry-validation
date: '2015-12-07'
categories:
- blog
tags:
- archives
- activemodel
- activerecord
- blog
- rails
- ruby
- validation
slug: introducing-dry-validation
aliases:
- "/2015/12/07/introducing-dry-validation"
---

We started experimenting with a new validation library under [dry-rb](https://github.com/dry-rb) organization a couple of months ago, and last month I released the first version of [dry-validation](https://github.com/dry-rb/dry-validation). Since then I worked hard on improving it and adding support for i18n.

Today, I released dry-validation 0.3.0 with a couple of bug fixes, new features and a complete support for i18n. Before I tell you what it is and how it can help you, let me start by explaining the reasoning behind this project.

## Problems With Validation in Rails

Most Ruby developers are used to handling data validation using `ActiveRecord`. Under the hood it uses `ActiveModel::Validations` and adds a couple of database-specific validations, like uniqueness. Since we’re dealing with parameters sent in an HTTP request, we also need coercions. This is handled by `ActiveRecord` for you, implicitly, since it knows what the expected types should be from database schema information and tries to coerce values correctly.

There are a couple of major issues here:

- Validation logic lives in two layers, controller and persistence, you need to remember about both to properly validate parameters
- “Strong parameters” used by Rails controllers is a very [poor API](http://gilesbowkett.blogspot.com/2015/05/strong-parameters-are-weak-schema.html), it’s not suitable for anything else except checking if keys in parameters are not missing and sanitizing the parameters by rejecting unexpected keys. It raises ambigious errors and is just a poor man’s params structure validation that replaced `attr_accessible`
- Validation in ActiveRecord/ActiveModel is full of ambiguity and unnecessary complexity. Lack of type safety and implicit coercion logic makes it hard to reason about such a crucial part of your system as data validation is. You don’t have type validations, so it’s hard to define validation rules that are type-dependant. Lack of explicit handling of “blank” values causes additional complexity like using `allow_blank` options. And these are just a couple of things from the top of my head
- DSL-based validations are overly complicated, validation macros support many options, including conditional logic with `:if` and `:unless`. Extending validations is hard, you have custom validation blocks, validating with custom methods or delegating validation to an external validator class. This gets out of control very quickly
- DSL is completely not suitable for nested data structures, it assumes you only want validations per-object and tries to work-around that with even more options, like `validates_associated`
- It’s based on the awkward concept that an object is validating its own internal state. This makes it inflexible and suitable only for this very use-case - validating objects. You can’t use it easily in other contexts, where you just want to validate data. I’ll explain why the whole idea of “an invalid object” is wrong in a separate article
- Coercing input from an HTTP request handled by persistence layer makes that layer more complicated without any good reason. It’s a relict of the original ActiveRecord design where a lot of seemingly related functionality was implemented in one layer

As a result, it is not reasonable to extend `ActiveModel::Validations` to make it work as a general-purpose validation solution, which I tried to do and failed and it’s pretty much the reason why `dry-validation` was born as an attempt to provide a general-purpose validation library that’s simple to use and extendible.

## Validations And Predicate Logic

In dry-validation the DSL is a thin layer on top of rule composition using predicate logic. Why predicate logic?

Consider this simple example, let’s say you want to create a user row in a database with 2 fields, a name and age. To describe validation rules for the user parameters you can say something like this:

> a user must have a name and a user must have age and age must be greater than 18

Let’s take a look at how it can be expressed in `ActiveModel::Validations` DSL:

```generic
class User < ActiveRecord::Base
  validates :name, presence: true
  validates :age, presence: true, numericality: { greater_than: 18 }
end

```

How well does this translate to the validation requirements? Which rule is violated when `:age` is an empty string? Both presence and numericality? The answer is yes, but in terms of logic it makes no sense, since the requirement is `present AND a number greater than 18` which means that the right side of `AND` shouldn’t be even checked.

This does not translate to the logical statement that explains the validations. I believe it is the reason why this DSL is ambigious and confusing. Notice that the same thing can be expressed using different macros where rules for the same value are scattered across multiple lines combined with rules for other values ie `validates :name, :age, presence: true`.

It seems like the reason why it works like that is because we need to display error messages for all the validations, and to get an error `ActiveModel::Validations` _must run a given validator_. I consider this as a design mistake and one of the many reasons why validations get overly complicated because code that does not have to be executed, is being executed, for a reason which is not relevant - to display information about a validation rule.

Here’s how the same thing is expressed using dry-validation DSL with predicates:

```generic
class UserSchema < Dry::Validation::Schema
  key(:name) { |name| name.filled? }
  key(:age) { |age| age.int? & age.gt?(18) }
end

```

Let’s examine that:

- `user.key(:name)` and `user.key(:age)` - we expect these _keys_ to be present
- `name.filled?` - AND we expect name value to be filled
- `age.int? & age.gt?(18)` - AND we expect age to be an integer AND it must be greater than 18

This is exactly how we logically described the validations in the sentence above. No macros, no options, just simple rule composition and predicate logic operators.

## Validation Schema vs Strong Parameters

In the previous examples we are missing one important part - checking the whole parameters structure. Since params are expected to contain the `:user` key, we need to handle that as well. With `ActiveRecord` you need to use “strong parameters” in the controller:

```generic
params.require(:user).permit(:name, :age)

```

What if `:user` is missing? You’ll get this:

```generic
ActionController::ParameterMissing Exception: param is missing or the value is empty: user

```

What if `:user` is an empty string? You’ll get this:

```generic
ActionController::ParameterMissing Exception: param is missing or the value is empty: user

```

What if `:user` is an empty hash? You’ll get this:

```generic
ActionController::ParameterMissing Exception: param is missing or the value is empty: user

```

What if `:user` is a non-empty array? Ha! Good question, you’ll get this:

```generic
NoMethodError Exception: undefined method `permit' for [{"name"=>"", "age"=>""}]:Array

```

It seems like I’m just picking on “strong parameters” without any good reason but my point is that if we wanted to fix those issues, it would become a…validation API. Right now it only causes confusion and provides ambigious low-level exceptions.

In dry-validation you can define a schema for params, in fact, you can be 100% precise about your expectations:

```generic
class UserSchema < Dry::Validation::Schema
  key(:user) do |user|
    user.hash? do
      user.key(:name) { |name| name.filled? }
      user.key(:age) { |age| age.int? & age.gt?(18) }
    end
  end
end

```

Let’s repeat our exercise now.

What if `:user` is missing? You’ll get this:

```generic
{:user=>[["user is missing", nil]]}

```

What if `:user` is an empty string? You’ll get this:

```generic
{:user=>[["user must be a hash", ""]]}

```

What if `:user` is an empty hash? You’ll get this:

```generic
{:user=>[{:email=>[["email is missing", nil]]}, {:age=>[["age is missing", nil]]}]}

```

What if `:user` is a non-empty array? You’ll get this:

```generic
{:user=>[["user must be a hash", [{}]]]}

```

Depending on your use case, you can either use a single schema to describe everything in one place, or use 2 validation schemas, one for structural validation and the other with detailed validation rules for all the values.

## Schema Validation And Coercions

Plain `dry-validation` schema does not perform coercions. When you’re dealing with params from an http request you want to use `Dry::Validation::Schema::Form` which is a specialized schema that infers coercions from your type expectations. Under the hood it uses [dry-data](https://github.com/dry-rb/dry-data) and its `from.*` coercible types category which is dedicated for coercing strings into other types. Not only is it very fast but also has nice handling of empty strings which are automatically turned into nils when your expectation is that a value _can be nil_. Apart from coercing values it also turns string hash keys into symbols, rather than using dubious concepts like “hash with indifferent access”.

Here’s how we could define the same user schema, but this time we will have coercions:

```generic
class UserSchema < Dry::Validation::Schema::Form
  key(:name) { |name| name.filled? }
  key(:age) { |age| age.int? & age.gt?(18) }
end

```

Now, since our expectation is that `:age` must be an integer, the built-in coercion mechanism will try to do the coercion for us:

```generic
user_schema = UserSchema.new

result = user_schema.call('name' => 'Jane', 'age' => '18')

puts result.params
# { :name => "Jane", :age => 18 }

```

Let’s tweak this and say that actually `:age` could be empty:

```generic
class UserSchema < Dry::Validation::Schema::Form
  key(:name) { |name| name.filled? }

  key(:age) { |age| age.none? | (age.int? & age.gt?(18)) }
end

user_schema = UserSchema.new

result = user_schema.call('name' => 'Jane', 'age' => '')

puts result.params
# { :name => "Jane", :age => nil }

```

Notice how explicit this is: “age is either empty OR age is an integer AND is greater than 18”.

## And There’s More!

This post is getting long already and it would’ve been way longer if I wanted to cover all features. Let me summarize what else is supported:

- 26 common, built-in predicates
- Support for defining your own ad-hoc predicates on the schema object
- Support for sharing common predicates between many schemas
- Support for coercions suitable for HTTP params in typical rack-based apps
- Support for nested structures, like hashes and arrays
- Support for optional keys
- Support for composing rules from other rules, ie. “confirmation of” validation that needs 2 values
- Support for I18n
- Support for providing custom error messages, including customizing messages per input type and predicate arguments
- Support for custom error compilers, ie. you could turn dry-validation errors into `ActiveModel::Errors`
- [Crazy fast](https://gist.github.com/solnic/aa011661616c2645f3df)

Please try it out and tell me what you think. In case you find an issue or you’d like to see a new feature, please report it on [GitHub](https://github.com/dry-rb/dry-validation/issues).
