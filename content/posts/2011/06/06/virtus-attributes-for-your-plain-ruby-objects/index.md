---
title: "Virtus - Attributes For Your Plain Ruby Objects"
date: "2011-06-06"
categories: 
  - "blog"
tags: 
  - "blog"
  - "oss"
  - "ruby"
  - "virtus"
---

I’m happy to announce the first release of Virtus gem. It is an extraction of DataMapper [Property API](http://datamapper.org/docs/properties.html) with various tweaks and improvements. If you like how properties work in DataMapper and would like to use such functionality in your plain ruby objects then you should give Virtus a try.

It is an early release but I would not expect many API changes before 1.0.0 since the code is based on the stable DataMapper API and I’m quite happy with it.

## How to install?

Virtus is just a gem and comes with **no dependencies**. To install just run this in your shell:

```generic
gem install virtus
```

Why?

As some of you know we’re starting to work on DataMapper 2.0. It will be a true implementation of the Data Mapper pattern and will use a certain set of libraries under the hood. Dan Kubb has already finished his absolutely fantastic relational algebra engine called
Veritas along with Veritas SQL Generator - these
gems will be the core part of DataMapper 2.0 Query System.

When we were talking with Dan about the future of Property API in DataMapper we both agreed we need an abstraction for defining your classes that would be
decoupled from any persistence logic. We also agreed that we actually don’t like “property” word in that context and would prefer #8220;attribute”. There you go - Virtus was borned :)

How does it work?

Virtus works in an almost identical way as Property in DataMapper. You can define attributes in your classes and it will create accessors to these attributes along with typecasting abilities. It comes with a set of builtin attribute types but you are free to add your own types too.

The API is dead-simple. Here’s an example class:
class Book
  include Virtus

  attribute :title,         String
  attribute :author,        String
  attribute :publish_date,  Date
  attribute :readers_count, Integer
end


This creates 4 attribute objects that are associated with your class. Each of these attributes is responsible for reading and writing values. Values are stored as standard instance variables.

You can easily inspect what attributes a class has:

pp Book.attributes

{:title=>
  #<virtus::Attributes::String:0x8aeb548
   @instance_variable_name="@title",
   @model=Book,
   @name=:title,
   @options={:primitive=>String, :complex=>false},
   @reader_visibility=:public,
   @writer_visibility=:public>,
 :author=>
  #<virtus::Attributes::String:0x8aea300
   @instance_variable_name="@author",
   @model=Book,
   @name=:author,
   @options={:primitive=>String, :complex=>false},
   @reader_visibility=:public,
   @writer_visibility=:public>,
 :publish_date=>
  #<virtus::Attributes::Date:0x8ae90e0
   @instance_variable_name="@publish_date",
   @model=Book,
   @name=:publish_date,
   @options={:primitive=>Date, :complex=>false},
   @reader_visibility=:public,
   @writer_visibility=:public>,
 :readers_count=>
  #<virtus::Attributes::Integer:0x8ae7e84
   @instance_variable_name="@readers_count",
   @model=Book,
   @name=:readers_count,
   @options={:primitive=>Integer, :complex=>false},
   @reader_visibility=:public,
   @writer_visibility=:public>}


Every attribute type has the primitive option set. When you are setting a value of an attribute, the corresponding attribute object will check if the value has the correct type. If the type doesn’t match the primitive, then the attribute will typecast the value.

Available Attribute Types

As I mentioned Virtus comes with various attribute types built-in:


Array
Boolean
Date
DateTime
Decimal
Float
Hash
Integer
Object
String
Time


These classes are organized in a hierarchy where Object inherits from an abstract Attribute class and all other types inherit from Object.

Options For Defining Attributes

When defining an attribute you can provide additional options. Every attribute class has a list of options that it accepts.

At the moment you can only use options for access control:
class User
  include Virtus

  attribute :name,  String,  :accessor => :public
  attribute :email, String,  :reader   => :protected
  attribute :age,   Integer, :writer   => :private
end


It is possible to set a default value of an option directly on an attribute class:
Virtus::Attributes::String.reader(:protected)

class User
  include Virtus

  # :reader option will be set to :protected
  attributes :name,  String
  # you can override the default if you want
  attributes :email, String, :reader => :public
end


Custom Attribute Types and Options

Just like in DataMapper you can implement your own attribute types. Whenever you need some twisted typecasting logic or you need to use extra options you can create a custom attribute class.

Here’s an example use-case - let’s say you want a hash and you need to stringify or symbolize the keys.
require ‘active_support/core_ext/hash/keys’
require ‘virtus’

module MyApp
  module Attributes
    class Hash < Virtus::Attributes::Object
      primitive ::Hash

      # Define extra options that this attribute class accepts
      accept_options :stringify_keys, :symbolize_keys

      # Set up default values for our extra options
      stringify_keys false
      symbolize_keys true

      # Typecast logic is depends on the options
      def typecast(value, object)
        if options[:stringify_keys]
          return value.stringify_keys
        end

        if options[:symbolize_keys]
          return value.symbolize_keys
        end
      end
    end
  end
end


Let’s use our custom attribute:
class Post
  include Virtus

  attribute :settings, MyApp::Attributes::Hash
  attribute :meta,     MyApp::Attributes::Hash, :stringify_keys => true
end

post = Post.new(
  :settings => { ‘foo’ => ‘bar’ },
  :meta     => { :foo  => ‘bar’ })

puts post.settings.inspect # => {:foo => ‘bar’}
puts post.meta.inspect     # => {‘foo’ => ‘bar’}


Other ORMs?

It’s a bit early to talk about that but I would love to see other Ruby ORM libraries using a common gem for model attributes. After we integrate DataMapper with Virtus it should be feasible for others like Mongoid, MongoMapper or even ActiveRecord (sic!) to use Virtus too. Well, at least that’s my ultimate goal.

Let’s not reinvent the wheel!

Resources

Here are links related to the project:


GitHub Repository
Virtus on RubyGems
Issue Tracker
API Docs


Enjoy!
```
