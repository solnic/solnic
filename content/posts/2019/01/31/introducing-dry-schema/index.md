---
title: "Introducing dry-schema"
date: "2019-01-31"
categories:
  - "blog"
tags:
  - "blog"
  - "dry-rb"
  - "dry-schema"
  - "dry-validation"
  - "oss"
  - "ruby"
  - "type-safety"
  - "validation"
---

Two years ago (!!!) I published [a post](https://discourse.dry-rb.org/t/plans-for-dry-validation-dry-schema-a-new-gem/215) on discourse.dry-rb.org explaining my plans for dry-validation 1.0.0 and in this post I mentioned that there will be a new gem called dry-schema that dry-validation will use for its schemas. It's crazy how time flies because I swear I thought it was last year. I know that over this time dry-validation has been accumulating a lot of issues (125 in the moment of writing this article), and I know it sucks, big time, that I didn't have a chance to address any of these.

Good news is I've finally shipped the first version of dry-schema, a new project I've been working on-and-off over the course of the last 2 years. It didn't actually take much time to build. According to GitHub, there were just 4 sprints of coding (I suspect it would be roughly one month of full-time work), just look at the commit graph:

![](/assets/images/Screenshot-2019-01-31-at-10.44.37.png)

During that time I had a couple of moments when I actually got completely stuck on how exactly something is supposed to work. A lot of thinking went into certain aspects of this project, with many discussions with [Tim](https://github.com/timriley) & [Nikita](https://github.com/flash-gordon) and other collaborators, trying to make the right decisions. Thank you for help everybody!

The end result is something I'm personally very happy about!

## What's dry-schema?

The sole purpose of dry-schema is to process and validate data input. There are many use cases for this library, most common ones are checking HTTP parameters (either GET or POST) and JSON data structures. If you're familiar with dry-validation, it's the same thing but without complex features like high-level rules or complex predicates.

When you see the word "validate", do not confuse it with validation similar to what people do in their Active Record models, or even "form" objects with `ActiveModel::Validations`. We're talking about validation of **the structure** and **basic checks**, which is meant to ensure that given data input **is safe** to work with.

## Breaking things down

In dry-schema data processing is broken down into 4 separate steps. This way we have the flexibility to add more advanced features in the future and it's easier to re-use existing functionality.

When you apply a schema 4 things happen:

1. Known keys are coerced, if needed, to symbols, unknown keys are rejected
2. (optional) Before trying to apply coercion, values can be checked using pre-coercion rules
3. Values are coerced, when needed, based on the type specifications in the schema
4. Keys and values are validated based on rules defined in the schema

The second step is optional, and it's only executed when you define "filter" rules, you'll learn more about this later.

## Improvements over dry-validation

The DSL in dry-validation is very powerful, unfortunately, its internal complexity made it very hard to improve. Rebuilding it from scratch was a better option, and this is what I did in dry-schema. It ships with a DSL very similar to dry-validation, but with many big improvements.

### Type specs

In dry-validation, type specs were introduced as an optional, opt-in feature, but it was never really finished and there are many bugs related to it. Luckily, in dry-schema type specs are core part of the DSL. This means every key has a type spec, by default it is set to `Types::Any`. DSL methods support type specs as their first argument, which is a major difference:

```ruby
Dry::Schema.Params do
  required(:age).value(:integer, gt?: 18)
end
```

There are a couple of important remarks here:

1. When a type is specified, a type-check predicate is inferred from it. In this case `:integer` is used to infer `:int?` predicate
2. The type will be used for coercion, **if you need coercion, specify the type**!

### Chaining rules

One of the nasty caveats in dry-validation was lack of support for chaining in the DSL. This is now resolved in dry-schema, here's an example:

```ruby
Dry::Schema.Params do
  required(:tags).value(:array, min_size?: 3).each(:str?, min_size?: 2)
end
```

This schema ensures that `:tags` is an array, with a minimum of 3 elements, where each element is a string that has the minimum length of 2.

### Key processing

When you apply a schema, keys are **always processed**. What it means is that **unknown keys are always rejected**. In case of `Params`and `JSON` schemas, keys are also coerced to symbols. This is handled by a separate step now, that used a new KeyMap object. There will be more features built on top of it, like producing error messages about unexpected keys (something that was requested many times before).

This is how it works:

```ruby
schema = Dry::Schema.Params do
  required(:name).filled
  required(:age).filled
  required(:address).schema do
    required(:country).filled
    required(:city).filled
    required(:street).filled
    required(:zipcode).filled
  end
end

schema.key_map
# #<Dry::Schema::KeyMap[
#   "name",
#   "age",
#   {"address"=>["country","city","street","zipcode"]}
# ]>
```

This gives us a nice object to work with, currently, it's only used to prepare a hash for further processing, but as you can see, it's also an introspection object giving you details about the key names. Furthermore, by making key processing a separate step, we have a place for additional validation of keys.

## Filter rules

A completely new feature that was added to dry-schema is "filter rules". This is something I was missing many, many times before. The idea is that there are cases, where you want to validate a value **before it is coerced**. A very common example is parsing date strings into Date objects. The way it typically works is that when value could not be coerced into a date, you get back the original value, and then validation fails that it is not a valid date. Now, the problem here is that we can't tell WHY it is not a valid date. The only knowledge we have is that coercion failed and the input is not a date object as a result.

With filter rules, you can specify criteria that input must meet in order to be successfuly processed by coercion and further validation. It can give a detailed validation error that will be more meaningful to you, and users of your system. Check out this example:

```ruby
schema = Dry::Schema.Params do
  required(:publish_on).filter(format?: %r[\d{4}-\d{2}-\d{2}]).value(:date)
end

schema.call(publish_on: '2019-2-1').errors
# {:publish_on=>["is in invalid format"]}
```

Notice the subtle difference that we can now validate both **original input** and **post-coercion output**. Typically, you won't need it, but once you do, I'm sure you will appreciate this feature!

## What's next?

With dry-schema initial release done, I can start working on dry-validation 1.0.0 :) For the time being, please try out dry-schema and report any issues. I would like to ask you for help, too. If you're affected by some bugs in dry-validation, **please try to reproduce them using dry-schema**. If a bug is fixed, please leave a comment under the corresponding issue on GitHub. This will be very helpful and appreciated. I want to address all the issues reported under dry-validation, and as you can probably imagine, going through all 125 of them will be a challenge for a single person:

Here are details about the project:

- Repository on GitHub [https://github.com/dry-rb/dry-schema](https://github.com/dry-rb/dry-schema)
- User docs [https://dry-rb.org/gems/dry-schema](https://dry-rb.org/gems/dry-schema) (help with docs is always needed!)
- The current version is 0.1.0 and it is a beta release, API is not 100% stable yet

Let me know if you have any questions, ideas or concerns!
