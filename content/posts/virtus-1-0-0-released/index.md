---
title: Virtus 1.0.0 Released
date: '2013-10-16'
categories:
- blog
tags:
- archives
- blog
- ruby
- virtus
slug: virtus-1-0-0-released
aliases:
- "/2013/10/16/virtus-1-0-0-released"
- "/virtus-1-0-0-released"
---

I’m happy to announce that after 1486 commits Virtus 1.0.0 has been released. It comes with a lot of neat changes, improvements and new features.

Here’s a quick summary of my favorite additions and changes.

## No more “include Virtus”

That’s right. With 1.0.0 including Virtus module is deprecated. Instead you should use something called “custom extension builder”. It’s really cool, check this out:

```generic
# for classes
class User
  include Virtus.model

  # attributes go here
end

# for modules
module CommonAttributes
  include Virtus.module

  # attributes go here
end

```

The reason for this change is that your classes and modules won’t be polluted with Virtus namespace…but that’s not everything…

## Configurable Modules

With the extension builder you can now build virtus modules that can hold custom configuration. This means you can set various options that will be used in your models and modules. This is a really sweet feature:

```generic
class User
  include Virtus.model(:coerce => false)

  attribute :name_that_will_not_be_coerced, String
end

```

This is my favorite change and on top of that we have…

## Cherry-pickable Extensions

NO WAY! Yes, way. You can now decide which features should be included. It’s as easy as that:

```generic
# this model won't have the constructor that accepts attribute hash
class User
  include Virtus.model(:constructor => false)

  # attributes go here
end

# and this one won't have mass-assignment
# which means #attributes and #attributes= won't be added
class Book
  include Virtus.model(:mass_assignment => false)

  # attributes go here
end

```

## Strict Coercion Mode

You can now use a special “strict” mode when you want to hear loud exceptions every time an input value failed to be coerced to the expected type:

```generic
# using module-level setting
class User
  include Virtus.model(:strict => true)

  attribute :age, Integer
end

# or the equivalent using per-attribute setting
class User
  include Virtus.model

  attribute :age, Integer, :strict => true
end

User.new(:age => 'very young') # BOOM! Virtus::CoercionError

```

## Public Attribute API

It’s now easy to create attribute instances on your own and use their public API:

```generic
attr = Virtus::Attribute.build(String)
attr.coerce('1') # => 1

# or maybe something more fancy
Money = Struct.new(:amount, :currency)

attr = Virtus::Attribute.build(Array[Money])
attr.coerce([[49, 'USD'], [29, 'EU']])
# => [
#      #<struct Money amount=49, currency="USD">,
#      #<struct Money amount=29, currency="EU">
#    ]

```

You can check out [Attribute API docs](http://rubydoc.info/github/solnic/virtus/v1.0.0/Virtus/Attribute) for more information.

## Lazy Defaults

In Virtus 0.5.x default value was being set when accessing an attribute for the first time. This has changed and now all default values are set in the constructor. If you want to have previous behavior just use :lazy option:

```generic
class User
  include Virtus.model

  attribute :email, String, :default => 'jane@doe.org'
  attribute :name,  String, :lazy => true, :default => 'Jane Doe'
end

user = User.new # :email is now set but :name remains as nil
user.name # :name is set to the default value

```

This change should address the performance issue that some people had when loading A LOT of virtus objects and reading A LOT OF attributes. Please keep in mind that it slows down initialization so if you find it problematic just set :lazy to true in your custom module or skip including virtus’ constructor.

## Finalization With Constant Name Evaluation

Finally the circular dependency problem with constant names has been resolved. Here’s how you can use it:

```generic
# user.rb
class User
  include Virtus.model(:finalize => false)

  attribute :address, 'Address'
end

# address.rb
class Address
  include Virtus.model(:finalize => false)

  attribute :street,  String
  attribute :city,    String
  attribute :zipcode, String
end

Virtus.finalize # this should be called after all your files were loaded

```

## There’s More!

There are more things to learn about this release so please check out [Changelog](https://github.com/solnic/virtus/blob/master/Changelog.md#v100-2013-10-16) and updated [README](https://github.com/solnic/virtus/blob/master/README.md).

If you find any issues please report them on [Github](https://github.com/solnic/virtus/issues?state=open).

## Future Plans For 2.0

Even though releasing 1.0.0 is a huge milestone for the project I’ve already started thinking about the future 2.0.0 version.

At the moment it seems like trimming down Virtus codebase is a good direction. Currently I’m considering removing complex coercion/mapping logic from Virtus and integrating it with [Ducktrap](https://github.com/mbj/ducktrap) which is a crazy powerful transformation algebra library. It’s still in its early days but is very promising. Virtus would remain as a “container” for various extensions providing nice DSL to configure them.

## Thank You!

I want to thank all of the [contributors](https://github.com/solnic/virtus/graphs/contributors) and everybody who helped me with testing early 1.0.0 betas and RCs.

Thanks! I really appreciate your help.

Have fun using Virtus 1.0.0 :)
