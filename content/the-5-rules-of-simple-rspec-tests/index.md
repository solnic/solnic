---
title: The 5 Rules of Simple RSpec Tests
date: 2021-05-11 13:36:41.000000000 +02:00
categories:
- blog
tags:
- archives
- programming
- ruby
- rspec
- bdd
- tdd
slug: the-5-rules-of-simple-rspec-tests
aliases:
- "/2021/05/11/the-5-rules-of-simple-rspec-tests"
---

The 5 "rules" **I try** to follow in order to write simple RSpec tests.

Let's GO.

## 1. Max 2 levels of describe/context nesting

**Everything above 2 is a code-smell** and causes alarm bells in my head to ring. The more levels of nesting you have, the harder it is to understand what a given example is doing. If you add before/after hooks to the mix, it'll become even worse.

I often reduce nesting by simply using example descriptions like that:

```ruby
RSpec.describe CreateUser do
  let(:create_user) do
    CreateUser.new
  end

  context "with valid params" do
    it "returns success" do
      expect(create_user.(name: "Jane", email: "jane@doe.org")).to be_success
    end
  end

  context "with invalid params" do
    it "returns failure when name is missing" do
      expect(create_user.(name: "", email: "jane@doe.org")).to be_failure
    end

    it "returns failure when email is missing" do
      expect(create_user.(name: "Jane", email: "")).to be_failure
    end
  end
end
```

Even though this could use more contexts and have attributes provided as per-context `let`s, I still prefer the simpler form. **There are cases where `let` is helpful but I'm optimizing for having as little nesting levels as possible.**

## 2. Top-down `let` definitions

When defining `let` statements, I do my best to organize a spec in a way that you don't have to jump from an inner describe/context block to outer blocks in order to understand the spec setup. This means that if you're reading a spec from the top, every subsequent `let` statement should ultimately lead you to a full understanding of the whole setup for a given spec example. **A setup where an inner `let` overrides an outter `let` is a code-smell.**

Here's an example of **what I try to avoid**:

```ruby
RSpec.describe CreateUser do
  subject(:create_user) do
    CreateUser.new
  end

  context "with valid params" do
    it "returns success" do
      expect(create_user.(name: "Jane", email: "jane@doe.org")).to be_success
    end
  end

  context "with invalid params" do
    # THIS RIGHT HERE - BAD, VERY BAD `LET`
    let(:create_user) do
      CreateUser.new(some_custom: "stuff for this example")
    end

    it "returns failure when name is missing" do
      expect(create_user.(name: "", email: "jane@doe.org")).to be_failure
    end

    it "returns failure when email is missing" do
      expect(create_user.(name: "Jane", email: "")).to be_failure
    end
  end
end
```

## 3. Meaningful example descriptions

I've stopped using short DSL syntax years ago. I used to do this:

```ruby
RSpec.describe CreateUser do
  subject do
    CreateUser.new
  end

  context "with valid params" do
    specify {
      expect(create_user.(name: "Jane", email: "jane@doe.org")).to be_success
    }
  end
end
```

You can streamline *a lot* with RSpec's powerful DSL but I prefer to **optimize for readability** and having nice descriptions is part of this. In general, I try to describe actual scenarios that can happen in the actual client code (as in, the code that will be using the thing I'm writing a spec for).

## 4. No mocking by default

I've stopped obsessing about "pure unit testing". This topic is big enough to have a separate post or even a series of posts about it but I'll try to summarize it here.

Using mocks in RSpec, even if you use verified doubles, is still prone to ending up with false-positivies. I feel uncomfortable every time I use a double, especially if it's not a verified double, and so I try to avoid mocking in general.

There are situations where mocking is absolutely helpful and justified - a great example is some kind of a 3rd-party authorization system. You definitely want to have it mocked in various testing scenarios.

If I were to come up with some guideline here, it would probably be this: **use a mock only if using the real thing causes *at least* one of the following problems**:

- Makes tests setup significantly more complex
- Makes tests significantly slower
- Causes *unwanted* and/or *problematic* side-effects in external systems (ie a file system)
- Depends on the internet connection

There's a lot that can be done to improve our "mocking situation" in the Ruby ecosystem in general. I've got some ideas how to achieve a truly safe and easy-to-work-with setup with mocks and stubs using our Hanami 2.0 setup, so stay tuned.

## 5. Higher tolerance to code duplication

There's this pretty good advise that you shouldn't "dry up" your code until you have the same concept repeated in more than 3 places. This works well but not in tests. That's why I have a much higher tolerance to duplication in tests. Reducing duplication in tests makes your setup more complex and we don't want that. **Simply be more wary when reducing duplication and make sure it's worth the extra complexity.**

This is *especially* relevant when you're using RSpec as it provides very powerful tools to reduce duplication. It's easy to overcomplicate your test suite when you go too far when trying to reduce duplication.

## Wrapping up
Overall this really boils down to the famous "with great power comes great responsibility" quote, very aplicable here. RSpec has a lot of features but you don't have to use all of them all of the time. What I really appreciate about RSpec though is that it works so well out of the box and its core built-in features are very helpful. It's a powerful tool so it takes time to learn how to use it effectively!

Last but not least, this is based on my personal experience with RSpec and your experience may be different. I'm more than happy to learn about your approach to writing simple and maintainable RSpec tests.
