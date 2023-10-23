---
title: New Virtus Release With Truly Awesome Features
date: '2012-02-08'
categories:
- blog
tags:
- archives
- blog
- datamapper
- patterns
- ruby
slug: new-virtus-release-with-truly-awesome-features
aliases:
- "/2012/02/08/new-virtus-release-with-truly-awesome-features"
---

Just a quick announcement that I just pushed a [new version](https://rubygems.org/gems/virtus/versions/0.2.0) of [Virtus](https://github.com/solnic/virtus) with support for long awaited features: EmbeddedValue, member type coercions for array/set attributes and ValueObject. Current version is 0.2.0, please give it a try and tell me what you think.

Here’s a quick sneak-preview of what you can do with Virtus:

```generic
class GeoLocation
  include Virtus::ValueObject

  attribute :lat, Float
  attribute :lng, Float
end

class City
  include Virtus

  attribute :name,      String
  attribute :location,  GeoLocation
  attribute :districts, Array[Symbol]
end

class User
  include Virtus

  attribute :name, String
  attribute :age,  Integer

  attribute :city, City
end

user = User.new(
  :name => ‘John’,
  :age  => 29,
  :city => {
    :name      => ‘NYC’,
    :location  => { :lat => ‘1234567.89’, :lng => ‘9876543.21’ },
    :districts => [ ‘one’, ‘two’, ‘three’ ]
  }
)

user.city.location.lat # => 1234567.89
user.city.districts    # => [ :one, :two, :three ]

```

I hope you’re going to enjoy it and find it useful in your projects. In case of any issues please report them on [Github](https://github.com/solnic/virtus/issues).

Huge props go to [Dan Kubb](https://github.com/dkubb), [Emmanuel Gomez](https://github.com/emmanuel) and [Yves Senn](https://github.com/senny) for helping me with recent releases! Thanks guys!
