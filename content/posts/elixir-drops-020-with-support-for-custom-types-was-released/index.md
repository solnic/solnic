---
title: Elixir Drops 0.2.0 with support for custom types was released!
date: '2024-02-01'
tags:
- library
- opensource
- data-structures
- elixir
- validation
slug: elixir-drops-020-with-support-for-custom-types-was-released
aliases:
- "/2024/02/01/elixir-drops-020-with-support-for-custom-types-was-released"
- "/elixir-drops-020-with-support-for-custom-types-was-released"
---

Since the previous release in October, my intermittent efforts have been dedicated to developing version 0.2.0 of Elixir Drops, concentrating primarily on enhancing its type system. The main objective has been to introduce the functionality for users to create custom types and to enable their composition.

I'm thrilled to share that today I've completed the work and released **Elixir Drops version 0.2.0**! Let's explore the new capabilities it brings.

## Defining custom types

You can encapsulate validation logic in simple custom primitive types. Let's say you want a user with `age` and `name` attributes, here's how you could define it:

```elixir
defmodule Types.Age do
  use Drops.Type, integer(gteq?: 0)
end

defmodule Types.Name do
  use Drops.Type, string(:filled?)
end

defmodule UserContract do
  use Drops.Contract

  schema do
    %{
      required(:name) => Types.Name,
      required(:age) => Types.Age
    }
  end
end

UserContract.conform(%{name: "Jane", age: 42})
# {:ok, %{name: "Jane", age: 42}}

{:error, errors} = UserContract.conform(%{name: "Jane", age: -42})
Enum.map(errors, &to_string/1)
# ["age must be greater than or equal to 0"]

{:error, errors} = UserContract.conform(%{name: "Jane", age: "42"})
Enum.map(errors, &to_string/1)
# ["age must be an integer"]
```

## Custom maps

Apart from defining custom primitive types, you can also define complex maps and reuse them easily. This is **very handy** as it can streamline schema definitions significantly.

Here's how we could define `Types.User` which is defined as a custom map, and then reuse it inside a `UserContract` under `:user` key:

```elixir
defmodule Types.User do
  use Drops.Type, %{
    required(:name) => string(:filled?),
    required(:age) => integer(gteq?: 0)
  }
end

defmodule UserContract do
  use Drops.Contract

  schema do
    %{
      required(:user) => Types.User
    }
  end
end

UserContract.conform(%{user: %{name: "Jane", age: 42}})
# {:ok, %{user: %{name: "Jane", age: 42}}}

{:error, errors} = UserContract.conform(
  %{user: %{name: "Jane", age: -42}}
)
Enum.map(errors, &to_string/1)
# ["user.age must be greater than or equal to 0"]

{:error, errors} = UserContract.conform(
  %{user: %{name: "Jane", age: "42"}}
)
Enum.map(errors, &to_string/1)
# ["user.age must be an integer"]
```

## Custom union types

You can now create your own union types, and this feature is also utilized by the newly introduced `Drops.Types.Number`. Consider a scenario where you require a price value that could be an integer or a floating-point number, with the common condition that it has to be more than 0:

```elixir
defmodule Types.Price do
  use Drops.Type, union([:integer, :float], gt?: 0)
end

defmodule ProductContract do
  use Drops.Contract

  schema do
    %{
      required(:price) => Types.Price
    }
  end
end

ProductContract.conform(%{price: 42})
# {:ok, %{price: 42}}

ProductContract.conform(%{price: 42.3})
# {:ok, %{price: 42.3}}

{:error, errors} = ProductContract.conform(%{price: -42})
Enum.map(errors, &to_string/1)
# ["price must be greater than 0"]

{:error, errors} = ProductContract.conform(%{price: "42"})
Enum.map(errors, &to_string/1)
# ["price must be an integer or price must be a float"]
```

## Elixir is 💜

I must admit, I am consistently impressed by Elixir and its (relatively!) straightforward approach to building even complex library code. Often, when I want to implement something more advanced, my gut feeling tells me it will be a challenge, but it usually turns out to be quite manageable. I also thoroughly enjoy the experience of refactoring things freely and then seeing how everything continues to work as expected. It's a truly amazing feeling!

When I started working on Drops last year, I wasn't entirely sure what to expect. I had about 1.5 years of Elixir experience, but my work mostly focused on application code. I had to learn how to build a library, how to write and organize tests for it, how to use more advanced macros or callbacks, and all of that was a very smooth ride.

This topic warrants an article of its own, which I hope to write someday. For now, I'm simply thrilled to continue working on Drops 🙂

## Greater things are yet to come 🤓

The new type system is a big stepping stone towards more great features that are scheduled for 0.3.0:

* I18n support with customized error messages

* A better casting implementation based on a common protocol (very similar to how the type system works)

* More built-in casters!


For more details about the current v0.2.0 please refer to [CHANGELOG.md](https://github.com/solnic/drops/blob/main/CHANGELOG.md#v020---2024-02-01).

I encourage you to try out Drops and see if it's useful to you. Feel free to provide any feedback and if you encounter any issues, please report them at [GitHub](https://github.com/solnic/drops/issues).

Add `{:drops, "~> 0.2"}` to your mix.exs and have fun!
