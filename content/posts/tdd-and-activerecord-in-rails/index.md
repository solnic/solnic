---
title: TDD and ActiveRecord in Rails
date: '2014-01-06'
categories:
- blog
tags:
- archives
- activerecord
- blog
- rails
- tdd
- testing
slug: tdd-and-activerecord-in-rails
aliases:
- "/2014/01/06/tdd-and-activerecord-in-rails"
- "/tdd-and-activerecord-in-rails"
---

I don’t have exact numbers but I believe TDD isn’t really popular amongst rails developers. This shouldn’t be a surprise given that the two of the most complex elements in the rails stack, models and controllers, are very convoluted concepts and are simply hard to test.

When you’re building a typical rails application most of the business logic lives in the active record models and controllers. Testing controllers in rails is a bit cumbersome but I still encourage people to write tests for them. What about active record models? How do you test them? Is it actually possible to test-drive active record models?

I’ve tried multiple approaches to testing ActiveRecord in Rails and I never liked what I was doing but for some reason I didn’t have any better ideas. More specifically:

- using rspec matchers like `it { should have_many(:comments) }`
- writing explicit tests for individual validations
- testing AR’s interfaces I don’t know if I actually use
- testing factories

You can’t really TDD ActiveRecord like that. It’s almost like wasting time.

## Behavior, fool!

When you practice TDD focusing on the behavior of the object under test is crucial. Turns out it’s not very different in ActiveRecord tests. Here’s the secret:

_Write tests for the methods you actually use._

Dooh? Yes, that simple. If you have a user model, don’t write tests checking when it’s valid or not. This doesn’t help much and the value of such tests is surprisingly small. For example:

```generic
describe User do
  it 'validates presence of a name' do
    user = User.new(:name => '')
    user.valid?

    expect(user.errors[:name]).to include("can't be blank")
  end
end

```

Sure, this checks _something_ but does it test what you are doing in the code when you’re interacting with an instance of the user model? Maybe. Maybe not. Who knows. You’d have to grep your app to find out. What you could do instead is to TDD the actual interface you’re using.

Let’s say your controller will want to create a user via `ActiveRecord.create` method. What’s important to aknowledge is that it will become the interface you will couple your code with. Make the decision and stick to it.

Once you do that you can write a test for the create method without weird tests checking multiple states of a user instance and how it would validate itself.

Let’s focus on the expected behavior of the user model that we will rely on:

```generic
describe User do
  describe '.create' do
    it 'persists a user with valid attributes' do
      user = User.create(:name => 'Jane')

      expect(user).to be_persisted
    end

    it 'does not persist if attributes are not valid' do
      user = User.create

      expect(user).not_to be_persisted
      expect(user.errors[:name]).to include("can't be blank")
    end
  end
end

```

This test is great because it specifies my expectation from the user model. I expect it to **behave** in a very specific way given valid and invalid attribute hash. It also communicates that in my code that’s how I’m going to create new users. I define the interface I will be using.

Of course the whole aspect of test-driven-**design** is not really present when we’re doing things like that. It’s more a test-first approach right now. Can we do better? Yes.

## Couple with your own interfaces

Forget about `#save`, `.create`, `.where` etc. Those are details, don’t expose them on the higher layers in your system. What you can do instead is to introduce your own interface to interract with the underlaying ActiveRecord objects.

Every interaction with the database is a use case. Capture that use case and write a test for it.

You want to do something? Great. What is it? Oh you want to create a user. OK that’s cool. When do you want to create it? When a post is sent from the sign up form. Awesome. Let’s do this.

```generic
describe User do
  describe '.create_on_signup' do
    it 'persists a user with valid attributes' do
      user = User.create_from_signup(:name => 'Jane')

      expect(user).to be_persisted
    end

    it 'does not persist if attributes are not valid' do
      user = User.create_from_signup(:name => '')

      expect(user).not_to be_persisted
      expect(user.errors[:name]).to include("can't be blank"))
    end
  end
end

```

Then in the controller you use that method instead of plain `.create`. It is much better because we captured a use case here. Having an explicit test for it is very valuable because we test exactly what we’re doing in the code rather than checking some ad-hoc behavior of our user model.

You can TDD entire model like that and you will end up with a better design. I can promise you that.

## Don’t be afraid of writing more ruby code

ActiveRecord models designed and implemented through this **dead simple process** are very easy to refactor. If you fancy service layer you can easily move things around and mock your interfaces in the unit tests for your service objects. Your code is easier to understand too. win-win.

Compare that with the classical approach when you’re using the concise and well thought-through the extremely wide and confusing interface of ActiveRecord all over the place in your system. Your code is coupled to X methods coming from ActiveRecord and your tests are probably checking 50% of what you are actually doing. That’s really bad!

It somehow happened that rails developers don’t like to write code and tend to think you can and should use what rails is giving you with as little code written by you as possible. And when somebody shows up telling you “hey, let’s be more explicit, reduce coupling, practice TDD, be more clear about our intentions” then, obviously, we hear one reply: OMG JAVA BURN YOU WITCH.

Rails is great, ActiveRecord, despite its issues, is a very powerful tool and can be used in a productive way allowing you to quickly build something. True.

This does not change the fact that the less you’re coupled to Rails interfaces, the better. Adding simple methods that communicate your intentions is way better than relying on “raw” interfaces exposed by Rails.

Don’t be afraid of writing a bit more ruby code. You said you love it after all. So what’s the problem?
