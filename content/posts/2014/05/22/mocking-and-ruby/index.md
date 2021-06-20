---
title: "Mocking and Ruby"
date: "2014-05-22"
categories: 
  - "blog"
tags: 
  - "blog"
  - "design"
  - "mocks"
  - "ruby"
  - "stubs"
  - "tdd"
  - "testing"
---

In the “TDD is dead” discussion unit testing and mocking is being mentioned frequently. DHH explicitly expressed how much he dislikes mocks and it seems like many people still connect unit testing with mocking or even confuse the two. In case you missed it Martin Fowler wrote [a great article](http://martinfowler.com/bliki/UnitTest.html) about what should be considered as a unit test. If you’re also confused about mocks and stubs I encourage you to read [Mocks Arent’ Stubs](http://martinfowler.com/articles/mocksArentStubs.html).

In this post I’d like to focus on mocking and Ruby, explaining the mistakes many of us were making and how we can improve our mocking skills.

## Mocking can be harmful

Here are terrible mocking practices that I’ve seen in Ruby projects (I’m guilty as charged so I know what I’m talking about):

- Mocking interfaces I don’t own (`User.stub(:find).with(1).return(user)` anyone?)
- Mocking for speed (increasing complexity of my tests just to avoid database calls etc.)
- Deep mocking (mocks returning mocks returning even more freaking mocks)
- Chain-method-call mocking
- Mocking internal parts of the system that aren’t part of the public interface (too rigorous isolation)

There are plenty of reasons why people started making those mistakes. Being annoyed with ActiveRecord is one for sure. Terribly slow rails test suites is another one. Or just drinking the mocking kool-aid as it was so simple with tools like rspec or mocha and everybody was doing it, right?

If you’re still wondering why those practices are simply harmful let me explain it quickly.

## Mock what you own, and mock it good

Mocking is a tool that you use to make dependencies and interfaces explicit. If an object has collaborators that expose a specific interface and if that interface happens to be used in multiple places then you have a great candidate to mock it. But _only if you own it_.

The reason for this is simple - if you don’t own something you have no control over its evolution. If you mock an interface from a 3rd party library your tests can suddenly start failing because the interface changed. If you hide 3rd party interfaces behind your own you have full control.

Additional benefit is narrowing down the interfaces. 3rd party libraries usually give you a lot of functionality and you almost never need all of it. I found that introducing your own interfaces simplify your code a lot because you rely on a small subset of what is actually available making your system much more coherent and simpler to change.

Here’s an example using [Bogus](https://github.com/psyho/bogus):

```generic
class Repository
  attr_reader :connection

  def initialize(connection)
    @connection = connection
  end

  def get(id)
    connection.find_by_id(id)
  end
end

class MyApp
  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def find_user(id)
    repository.get(id)
  end
end

describe MyApp do
  subject(:my_app) { MyApp.new(repository) }

  fake(:repository)

  describe '#find_user' do
    it 'returns a user found by repository' do
      user = 'some user'

      mock(repository).get(1) { user }

      expect(my_app.find_user(1)).to be(user)

      expect(repository).to have_received.get(1)
    end
  end
end

```

The important thing is to understand what this test is telling us and it goes like this “MyApp uses a collaborator called `:repository` and relies on its interface defined as `get(Fixnum)` which returns a user object”.

And here’s what we often forget about:

```generic
describe Repository do
  verify_contract :repository

  subject(:repository) { Repository.new(connection) }

  let(:connection) { SomeImaginary3rdPartyConnection.new }

  describe "#get" do
    it "finds a user by id" do
      expect(repository.get(1)).to eql('some user')
    end
  end
end

```

Yes, an integration test, a very important integration test that verifies the contract. What contract? This: `Repository#get(1)`. This is what we depend on, this is what we mocked, we can’t mock something that is not known to work correctly.

See that `verify_contract(:repository)` line? Bogus will yell at you if there are any repository mocks with interfaces that have not been tested.

## Don’t mock for speed

Slow tests are telling you that there are too many parts in your system that heavily rely on external resources that are slow. You should not start mocking those slow parts and fake responses. Instead you should extract the logic where the tight coupling with the slow resources is not really needed.

Maybe a given object has too many responsibilities, maybe it doesn’t really need to know that the data its concerned with come from a remote API call. Separation of concerns and improving the general design of your system will speed up your test suite. Don’t get fooled with mocking for speed.

Remember that unjustified usage of mocking just to have a faster test suite will _highly increase the maintainance cost of that suite_ and it _will not_ improve the design of your system. It will probably make it worse.

## Keep mocking simple

I love RSpec, I really do but its mocking interface is too wide giving you ways to write tests that are complex and hard to maintain. My personal pet-peeve is the usage of `any_instance` - what does that even mean? You want to be explicit about method call expectations but you can’t really tell _where_ a given dependency is instantiated, what owns it and where it is used?

Mocking should be simple and very explicit. If you’re writing a unit test for an object with 2 collaborators that you want to mock then _2 mocks_ is all you should need. If you happen to use more then there’s a problem with your design.

Mocking, maybe surprisingly to some people, can be used to _simplify your tests_ and _improve the design of your system_. If you see additional complexity added by mocks then you can be sure the way they are used is wrong.

Mocks returning mocks, mocking chained-method calls - this is terrible complexity added to your tests that only tells you one thing: _you are missing some abstractions_.

Keep mocking simple and it will guide you towards simpler, cleaner design and increase the cohesion of your system.

## Or maybe just don’t mock!

I happen to use mocks way less often than I used to. The reason for this is that I only want to use mocking when I want to isolate my code from 3rd party libraries (doesn’t happen so often) or when I introduce an explicit dependency that is used in many places in my system (not just in one class).

Sometimes I use mocking to design the interfaces but I found it to be less productive than to just experiment a little, see how the code evolves and once I become confident that a given interface looks good and shouldn’t change much I only then want to start mocking it.

Mocking costs extra time that’s why I prefer to be careful about it.
