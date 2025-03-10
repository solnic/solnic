---
title: Introducing Elixir Drops
date: '2023-10-25'
tags:
- library
- opensource
- data-structures
- elixir
- validation
slug: introducing-elixir-drops
aliases:
- "/2023/10/25/introducing-elixir-drops"
- "/introducing-elixir-drops"
---

A few years ago my Ruby friends asked me if it would be possible to port some of the [dry-rb](https://dry-rb.org) libraries to Elixir. I remember some early community attempts at porting dry-validation specifically, I did my best to support the effort but back then my Elixir knowledge was too basic and I was too busy with other work.

Fast forward to today and **I'm happy to announce the very first release of Elixir Drops**! 🎉 In this article I'll introduce you to the concepts of the library and show you how you could use it.

## Contracts with schemas

One of the core features of Drops is its Contract extension with the Schema DSL. It allows you to define the exact shape of the data that your system relies on and data domain validation rules that are applied to type-safe data that was processed by the schema.

There are multiple benefits of this approach:

* Casting and validating data using schemas is very precise, producing detailed error messages when things go wrong

* Schemas give you **type safety** at the boundaries of your system - you can apply a schema to external input and be 100% sure it's safe to work with

* It's very easy to see the shape of data, making it easier to reason about your system as a whole

* You can restrict and limit larger data structures, reducing them to simpler representations that your system needs

* It's easy to convert *schemas* to other representations ie for documentation purposes or export them to JSON Schema format

* Schemas capture both the structure and the types of data, making it easy to reuse them across your codebase

* Your **domain validation rules** become simple and focused on their essential logic as they apply to data that meets type requirements enforced by schemas


This of course sounds very abstract, so here's a simple example of a data contract that defines a schema for a new user:

```elixir
defmodule Users.Signup do
  use Drops.Contract

  schema do
    %{
      required(:name) => string(:filled?),
      optional(:age) => integer()
    }
  end
end

Users.Signup.conform(%{
  name: "Jane Doe",
  age: 42
})
# {:ok,
#  %{
#    name: "Jane Doe",
#    age: 42
#  }}

{:error, errors} = Users.Signup.conform(%{})

Enum.map(errors, &to_string/1)
# ["name key must be present"]

{:error, errors} = Users.Signup.conform(%{
  name: "",
  age: "42"
})

Enum.map(errors, &to_string/1)
# ["age must be an integer", "name must be filled"]
```

Let's take a closer look at what we did here:

* The contract defines a schema with two keys:

    * `required(:name)` means that the input map is expected to have the key `:name`

    * `string(:filled?)` means that the `:name` must be a non-empty string

    * `optional(:age)` means that the input *could* have the key `:age`

    * `integer()` means that the `:age` must be an integer


Even though this is a very basic example, notice that the library does quite a lot for you - it processes the input map into a new map that includes only the keys that you specified in the schema, it checks both **the keys** and **the values** according to your specifications. When things go wrong - it gives you nice error messages making it easy to see what went wrong.

## Type-safe Casting

One of the unique features of Drops Schemas is type-safe casting. Schemas breaks down the process of casting and validating data into 3 steps:

1. Validate **the original input values**

2. Apply optional casting functions

3. Validate **the output values**


It's better to explain this in code though:

```elixir
defmodule Users.Signup do
  use Drops.Contract

  schema do
    %{
      required(:name) => string(:filled?),
      optional(:age) => cast(string(match?: ~r/\d+/)) |> integer()
    }
  end
end

Users.Signup.conform(%{
  name: "Jane Doe",
  age: "42"
})

{:error, errors} = Users.Signup.conform(%{
  name: "Jane Doe",
  age: ["oops"]
})

Enum.map(errors, &to_string/1)
# ["cast error: age must be a string"]

{:error, errors} = Users.Signup.conform(%{
  name: "Jane Doe",
  age: "oops"
})

Enum.map(errors, &to_string/1)
# ["cast error: age must have a valid format"]
```

Notice that when the age input value cannot be casted according to our specification, we get a nice "cast error" message and we immediately know what went wrong.

## Domain validation rules

Contracts allow you to split data validation into schema validation and arbitrary domain validation rules that you can implement. Thanks to this approach we can focus on the essential logic in your rules as we don't have to worry about the types of values that the rules depend on.

Let me explain this using a simple example:

```elixir
defmodule Users.Signup do
  use Drops.Contract

  schema do
    %{
      required(:name) => string(:filled?),
      required(:password) => string(:filled?),
      required(:password_confirmation) => string(:filled?)
    }
  end

  rule(:password, %{password: password, password_confirmation: password_confirmation}) do
    if password != password_confirmation do
      {:error, {[:password_confirmation], "must match password"}}
    else
      :ok
    end
  end
end

Users.Signup.conform(%{
  name: "John",
  password: "secret",
  password_confirmation: "secret"
})
# {:ok, %{name: "John", password: "secret", password_confirmation: "secret"}}

{:error, errors} = Users.Signup.conform(%{
  name: "John",
  password: "",
  password_confirmation: "secret"
})

Enum.map(errors, &to_string/1)
# ["password must be filled"]

{:error, errors} = Users.Signup.conform(%{
  name: "John",
  password: "foo",
  password_confirmation: "bar"
})

Enum.map(errors, &to_string/1)
# ["password_confirmation must match password"]
```

Here we check whether `password` and `password_confirmation` match but first we define in our schema that they must be both non-empty strings. Notice that our domain validation rule **is not applied at all** if the schema validation does not pass.

As you can probably imagine, this type of logic could be easily implemented as a higher-level macro, something like `validate_confirmation_of :password`. This is something that I'll most likely add to Drops in the near future.

## Safe map atomization

Another very useful feature is support for atomizing input maps based on your schema definition. This means that the output map will include only the keys that you defined turned into atoms, in the case of string-based maps.

Here's an example:

```elixir
defmodule Users.Signup do
  use Drops.Contract

  schema(atomize: true) do
    %{
      required(:name) => string(:filled?),
      optional(:age) => integer()
    }
  end
end

Users.Signup.conform(%{
  "name" => "Jane Doe",
  "age" => 42
})
# {:ok, %{name: "Jane Doe", age: 42}}
```

## About the first release

Today I'm releasing v0.1.0 of Drops and even though it's the first release, it already comes with a lot of features! It's already used in our backend system at [valued.app](https://valued.app), processing and validating millions of JSON payloads regularly.

It is an early stage of development though and I encourage you to test it out and provide feedback! Here are some useful links where you can learn more:

* [Repo on GitHub](https://github.com/solnic/drops)

* [Project on GitHub](https://github.com/users/solnic/projects/2)

* [Discussions on GitHub](https://github.com/solnic/drops/discussions)

* [Package on hex.pm](https://hex.pm/packages/drops/0.1.0)

* [Documentation on hexdocs.pm](https://hexdocs.pm/drops/0.1.0/readme.html)


Check it out and let me know what you think!
