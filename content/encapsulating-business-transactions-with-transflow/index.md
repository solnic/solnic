---
title: Encapsulating Business Transactions With Transflow
date: '2015-08-17'
categories:
- blog
tags:
- archives
- blog
- oss
- ruby
slug: encapsulating-business-transactions-with-transflow
aliases:
- "/2015/08/17/encapsulating-business-transactions-with-transflow"
---

It’s a known fact that when you deal with a big problem it’s good to split it into smaller problems, solve them in isolation using separate components and use an integration layer to combine them into a single unit. Unfortunately it’s easier said than done. In an OO language like Ruby there are countless approaches you can take to tackle complex scenarios in your application.

Objects accumulating state, which gets mutated as a result of some business transaction, is already a complex thing to deal with. Turn that into a series of operations where each can mutate something and you can no longer reason about anything.

After spending some time working on [functional data transformations](/2015/04/16/introducing-transproc-functional-data-transformations-for-ruby.html) and [ROM](http://rom-rb.org), and diving into some functional languages a bit, I realized I want to tackle complex business transactions in the same way - by using simple function-like objects that respond to `#call`, receive input and return output, without causing any side-effects.

And so I sat down yesterday and wrote [Transflow](https://github.com/solnic/transflow). Its first beta version is already on Rubygems.

## Business Transactions?

A client sends a request to your application, your application sends a response; in the process of producing that response, many things need to happen - that’s a business transaction, a series of operations, each requiring some input to produce some output, where the last one returns the final response.

I really like showing simple concepts using procs, so here we go:

```generic
parse_input = -> input { JSON.parse(input) }
validate_input = -> input { input.key?(:id) ? input : raise("oops :id missing") }
find_user = -> input { user_repo.find(input.fetch[:id]) }

# a client asks for a user so:

input = '{"id": 1}'

find_user.call(
  validate_input.call(
    parse_input.call(input)
  )
)

```

I hear you screaming “that’s so not OO!”. I know, right. Bear with me.

The first thing to realize is that we capture the essence of what needs to happen. Do we need any state? Nope. So we use simple procs, it works well enough.

The second thing that we’re dealing with is transforming a string with a json request into another json string with the response. It requires some intermediate processing, validation and persistence, all of which can be nicely encapsulated using separate, re-usable components.

However, defining procs (or other callable objects) and calling them manually every time you use them would be too tedious, too much boilerplate. That’s why `Transflow` was created.

## Defining a Transaction With Transflow

The gem provides an interface to define a business transaction flow. You must provide a container object which resolves objects that will handle individual steps. The rest is a simple DSL sugar on top of callable object composition.

Let’s define a transaction for our use-case:

```generic
parse_input = -> input { JSON.parse(input) }
validate_input = -> input { input.key?(:id) ? input : raise("oops :id missing") }
find_user = -> input { user_repo.find(input.fetch[:id]) }

container = {
  parse_input: parse_input, validate_input: validate_input, find_user: find_user
}

transflow = Transflow(container: container) do
  steps :parse_input, :validate_input, :find_user
end

input = '{"id": 1}'

transflow.call(input) # returns the user

```

This sounds almost too simple. So let’s say we actually want to update the user using the parsed input and then return it to the client.

Remember that each operation returns a result that is passed to the second one, this means you can simply do this:

```generic
parse_input = -> input { JSON.parse(input) }
validate_input = -> input { input.key?(:id) ? input : raise("oops :id missing") }

find_user = -> input { { input: input, user: user_repo.find(input.fetch[:id]) } }
update_user = -> input:, user: { user_repo.update(input, user) }

container = {
  parse_input: parse_input,
  validate_input: validate_input,
  find_user: find_user,
  update_user: update_user
}

transflow = Transflow(container: container) do
  steps :parse_input, :validate_input, :find_user, :update_user
end

input = '{"id": 1}'

transflow.call(input) # returns the updated user

```

## Subscribing to Events

In many cases an external handler needs to be invoked when something happens. For example, in most systems, an email must be sent when a new user is created, or some background job must be scheduled when something is updated. Or maybe we need to write to a special log file when something _fails_.

With Transflow, you can subscribe event listeners to individual steps thanks to the awesome `wisper` gem.

It’s as simple as:

```generic
transflow = Transflow(container: container) do
  step :parse_input do
    step :validate_input do
      step :find_user do
        # this step will publish a `:update_user_success` or `:update_user_failure` event
        step :update_user, publish: true
      end
    end
  end
end

class UserEventListener
  def self.update_user_success(user)
    # do something
  end

  def self.update_user_failure(user, error)
    # do something
  end
end

input = '{"id": 1}'

transflow.subscribe(update_user: UserEventListener)

transflow.call(input) # returns the updated user and triggers UserEventListener

```

## Container? Procs? What the heck

I’m using procs in the examples but please remember you can use _anything_ that responds to `#call()`. If you’re wondering what’s the deal with the container - it’s a simple concept that makes Transflow unaware of the type of objects you’re using in your application. It focuses purely on composition, error handling and optional event publishing. This allows you to compose complex business transactions from small pieces and Transflow does not make any assumptions about your objects, it only relies on `#call()` interface.

## Try it Out

If you’ve got complex scenarios in your application, try to decompose them into small, well encapsulated, callable objects and compose them into a transaction with Transflow. Even when your code doesn’t match the interface Transflow requires, it’s very easy to wrap your code with procs, give them meaningful names and compose a transaction using them.

There are more usage examples in the [README](https://github.com/solnic/transflow#synopsis).

Let me know what you think. I already ported a couple of crazy complex controller actions and it feels really good :)
