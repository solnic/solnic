---
title: Making ActiveRecord Models Thin
date: '2011-08-01'
categories:
- blog
tags:
- archives
- activerecord
- blog
- ddd
- patterns
- rails
- ruby
- tdd
slug: making-activerecord-models-thin
aliases:
- "/2011/08/01/making-activerecord-models-thin"
- "/making-activerecord-models-thin"
---

“Skinny Controller, Fat Model” is a well known best practice in Ruby community. Everybody seems to agree with it and follows it. It’s pretty clear what a skinny controller is. The question is what is a fat model and what should we do if it gets too fat? Even better, what should we do to avoid too fat model? I think many people still confuse Domain Model with ActiveRecord. It’s something more and in this post I will try to explain my new approach to writing Ruby on Rails applications.

Also, I would like to thank Steve Klabnik who triggered the process of writing this post by tweeting this:

> We need something better. Persistence and logic are two separate responsibilities that every rails app combines.
>
> **Steve Klabnik** [twitter.com/#!/steveklabnik/…](http://twitter.com/#!/steveklabnik/status/96260768823123968)

I’m really glad more and more people are starting to realize this.

## Behavior vs Data

When we say “model” we usually think about ActiveRecord. In Ruby on Rails world this is how we established things. “M” in the MVC means app/models with a bunch of ActiveRecord model files. This is where the domain logic of our applications lives. I think we should stop thinking like that.

Martin Fowler defines Domain Model as:

> An object model of the domain that incorporates both behavior and data.
>
> **Martin Fowler** [martinfowler.com/eaaCatalog/…](http://martinfowler.com/eaaCatalog/domainModel.html)

We should remember though that the way your Domain Model _behaves_ and the way your data are _persisted_ are two separate concerns. ActiveRecord objects represent your data. They give you a low level interface to access your data. Yes, low level. If you mix domain specific behavior into ActiveRecord models you will create classes with too many responsibilities. By violating [Single Responsibility Principle](http://en.wikipedia.org/wiki/Single_responsibility_principle) model code becomes difficult to extend, maintain and test. I have seen it many times, I’m pretty sure you have too.

A few months ago I stumbled upon this quote:

> I pull the behavior out of my models into other objects that wrap the models. I prefer to make the AR objects simple wrappers around the db-access stuff in AR.
>
> I have a fairly strict rule that controller actions cannot use AR finders or, in fact, interact with AR at all. AR should be accessed within api methods inside your model, not from the outside.
>
> **Corey Haines** [www.adomokos.com/2011/04/…](http://www.adomokos.com/2011/04/running-rails-rspec-tests-without-rails.html?showComment=1302880085636#c8190505485489994604)

This describes exactly what I’ve started doing in my recent Rails projects. The outcome of this approach is more than great. I literally left ActiveRecord models with only validation rules, scopes and before/after hooks. The rest is handled by a separate class hierarchy with domain-specific functionality. Those clases use ActiveRecord models only for the persistence.

## Well Defined API

Something that always bothers me in a typical Rails application is the lack of a well defined model API. Your Domain Model should have an interface to every action your application should be able to perform. If you have an online shop where a user can buy a product then with a well-written Rails application you should be able to fire up the console and be able to _easily_ perform this operation. If it’s not so simple then you probably want to think about your model implementation again.

What makes it so hard for us to design and implement a good API for our model? In my opinion it happens because we _start with the data_ instead of behavior. For example if you’re building an online shop, how do you start the design and implementation process? In Rails you probably create migration files to create a db schema. Right? You initially think about the database columns you need to create and validation rules you need to define in the models. After you have all this done you start thinking about the behavior. You add various methods to your ActiveRecord models so they can create new objects, validate and persist them. In the end both data and behavior of your system is mixed together in ActiveRecord models. If you change a column in some table, your system stops working and it’s relatively difficult to fix. Why? Because the domain behavior is tightly coupled with the database schema. Because you started with the db schema and added behavior later.

How about reversing that process and starting with the behavior implemented in separate classes that are not coupled with the database schema? This way you will define your API at a higher level. What’s more important you will _start_ with an API and you will add the persistence logic later.

## Behavior & API

The key difference between using ActiveRecord models and domain model classes is that in case of the latter you clearly specify the behavior. For instance if I want to find a product in my online shop, how do I do that? Well, with ActiveRecord Product model I have plenty of choices. I can #find or #find_by_id or #where(:id => id).first etc. This is problematic because the same operation can be done in many different ways. Our goal is to create _a consistent_ behavior that is the same in every place of our application.

Let’s use a simplified example of an online shop and focus on one core behavior - selling a product. Here’s a code spike how it could be modeled:

```generic
class Shop
  class Warehouse
    def self.find(id)
      # returns a product
    end
  end

  class Customer
    attr_reader :user

    def self.find(id)
      # returns a user
    end

    def initialize(user)
      @user = user
    end

    def pay(product)
      # perform the payment
    end
  end

  class Transaction
    attr_reader :customer, :product, :status

    def initialize(customer, product)
      @customer   = customer
      @product = product
    end

    def commit
      @status = customer.pay(product)

      if success?
        commit!
      end
    end

    def commit!
      # do some stuff to persist data about a successful transaction
    end

    def success?
      status === true
    end
  end
end

```

So, Warehouse can find a product, Customer can find a user, a customer instance can pay for a product and Transaction handles selling a product to a customer. With this ridiculously basic example let’s see how we can write a spec for Transaction:

```generic
describe Shop::Transaction, '#commit' do
  subject { transaction.commit }

  let(:user)        { mock('customer') }
  let(:product)     { mock('product') }
  let(:transaction) { described_class.new(customer, product) }

  before do
    customer.should_receive(:pay).with(product).and_return(payment_status)
  end

  context 'when payment is successful' do
    let(:payment_status) { true }

    its(:success) { should be(true) }
  end

  context 'when payment is not successful' do
    let(:payment_status) { false }

    its(:success) { should be(false) }
  end
end

```

Running the spec gives you this output:

```generic
Shop::Transaction#commit
  when payment is successful
    success
      should equal true
  when payment is not successful
    success
      should equal false

Finished in 0.00182 seconds
2 examples, 0 failures

```

This way we started off by defining our API, it’s pretty simple to use:

```generic
customer    = Shop::Customer.find(customer_id)
product     = Shop::Warehouse.find(product_id)
transaction = Shop::Transaction.new(customer, product)

transaction.commit

```

Note that we designed and implemented the behavior and we could easily write a spec that checks if that behavior is correct. What about real data and persistence?

## Behavior + Persistence

To continue with the shop example let’s add ActiveRecord models:

```generic
class User &lt; ActiveRecord::Base
  validates :email, :name, :presence => true
end

class Product &lt; ActiveRecord::Base
  validates :name, :sold, :presence => true
end

class Order &lt; ActiveRecord::Base
  belongs_to :user
  belongs_to :product
end

```

Now let’s use these models in our domain model classes:

```generic
class Shop
  class Warehouse
    def self.find(id)
      Product.find_by_id(id)
    end
  end

  class Customer
    attr_reader :user

    def self.find(id)
      User.find_by_id(id)
    end

    def initialize(user)
      @user = user
    end

    def pay(product)
      # perform the payment
    end
  end

  class Transaction
    attr_reader :customer, :product, :order, :status

    def initialize(customer, product)
      @customer = customer
      @product  = product
    end

    def commit
      @status = customer.pay(product)

      if success?
        commit!
      end
    end

    def commit!
      create_order

      if order.persisted?
        mark_product_as_sold
      end
    end

    def success?
      status === true
    end

    private

    def create_order
      @order = Order.create(:user => customer, :product => product)
    end

    def mark_product_as_sold
      @product.update_attribute(:sold, true)
    end
  end
end

```

This way we hide all the details about our db schema behind objects holding the domain logic behavior of our shop application. If something changes with the ActiveRecord models you will only need to change the implementation in one place because there’s one way of finding a user and a product and placing an order.

## Testing Benefits

With the approach I described it’s really easy to write solid tests. You can test the behavior in a complete isolation from the db models which results in fast execution of those tests. Most of the logic of your system can be unit-tested without touching the database, this means thousands of test examples running in less than a second. On the other hand when testing ActiveRecord models you are only concerned about validation rules, hooks and finder methods cause there’s no more logic there. It makes the AR tests _really clean_ and easy to maintain.

## Feedback?

I understand that it may seem like a heavy approach and Ruby on Rails is all about rapid development and writing less code. However, every project I’ve seen that evolved in something more than a blog written in 15 minutes, sooner or later become a huge mess. I don’t think programmers are guilty here. We’ve been taught to use certain tools and practices and now it’s time to move on, take a step forward.

Still here? Awesome! I would love to get feedback about how you’re dealing with complex logic in your Rails applications - so feel free to comment and let’s start an interesting discussion.
