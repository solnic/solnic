---
title: Importing Data With ROM and Transproc
date: '2015-07-15'
categories:
- blog
tags:
- archives
- blog
- data
- oss
- rom
- ruby
- transproc
slug: importing-data-with-rom-and-transproc
aliases:
- "/2015/07/15/importing-data-with-rom-and-transproc"
- "/importing-data-with-rom-and-transproc"
---

Importing data into a database can be a complicated task. This process can be quite painful as you need to deal with data transformation, filling in missing information, specifying validation rules, handling errors and so on. Without proper tools to solve this problem it can become more complicated than it should be.

In my current project at work I’m dealing with exactly that problem - we’re importing data from YAML documents into a PostgreSQL database. This time I didn’t use popular Ruby tools like ActiveRecord, instead, I decided to leverage the powerful features of [ROM](http://rom-rb.org) - which turned out to be a great choice.

In this post I’ll show you the approach I used and explain how it works.

## Pieces of the puzzle

For importing data we need three essential pieces:

- Validations
- A data mapper
- A persistence handler

Validations must work with the original input data in order to provide meaningful error messages to the client. A data mapper needs to transform the input into a persistable data structure, and finally, our persistence handler will know how to store the transformed data in our database.

It is important to see the boundaries here, otherwise the code would be overly complicated when too many concerns are handled in the same layer.

Luckily for us ROM provides exactly what we need and allows us to accomplish the task with a minimum effort:

- `ROM::Model::Validator` is a validation extension which is part of the rom-rails gem. It is built on top of ActiveModel::Validations and has extra features like embedded validators, which are very helpful when dealing with nested data structures
- `ROM::Mapper` is a standalone pure data mapping extension allowing you to define advanced data transformations
- `ROM::Command` is an API that allows you to define persistence commands that can create, update or delete data in a database. It has support for combining multiple commands into a single command that can persist entire object graphs

With those tools available, and by using a couple of simple “tricks”, you can build a really powerful data import solution.

Following gems are involved:

- [rom 0.8](https://github.com/rom-rb/rom) - for mappers and handling persistence
- [rom-rails 0.4](https://github.com/rom-rb/rom-rails) - for validators and command attributes handlers
- [transproc 0.3](https://github.com/solnic/transproc) - for lazy-evaluation

## Data Import Flow

There are four steps, at a high-level, that we need to take in order to import the data:

1. Preprocess raw input
2. Validate input
3. Transform validated input into a persistence-compatible structure
4. Persist prepared data

Each of these steps is essential to ensuring that the data is prepared for the next step, in a way that will reduce complexity. If you try to handle all of those concerns in just one layer, like when using ActiveRecord, the complexity grows exponentially and the boundaries are completely blurred making it harder to change anything.

Let’s focus on individual steps one-by-one.

## Preprocessing

We’ll use a very simple data structure for the raw input, but, you can probably imagine that it could be really complex. Let’s assume, for the sake of this example, that we’re importing library data about authors and their books from a JSON-like document into a relational database. We are dealing with documents in the input and we need to transform that into relations in order to persist it.

The first step is to preprocess the raw input, so that we have a sanitized structure with any unexpected keys being rejected, and valid keys being symbolized:

```generic
raw_input = [
  {
    'author_name' => 'Jane Doe',
    'author_email' => 'jane@doe.org',
    'author_uid' => 'jd',
    'books' => [
      {
        'title' => 'First',
        'publication_date' => '2010-10-10'
      },
      {
        'title' => 'Second',
        'publication_date' => '2011-11-11'
      },
      {
        'title' => 'Third',
        'publication_date' => '2012-12-12'
      }
    ]
  }
]

```

The input can be easily preprocessed by a ROM mapper:

```generic
class Preprocessor < ROM::Mapper
  symbolize_keys true
  reject_keys true

  attribute :author_uid
  attribute :author_name
  attribute :author_email

  embedded :books, type: :array do
    attribute :title
    attribute :publication_date
  end
end

preprocessor = Preprocessor.build

preprocessor.call(raw_input)
# => [{:author_name=>"Jane Doe", :author_email=>"jane@doe.org", :books=>[{:title=>"First", :publication_date=>"2010-10-10"}, {:title=>"Second", :publication_date=>"2011-11-11"}, {:title=>"Third", :publication_date=>"2012-12-12"}]}]

```

## Input Data Validators

This is a really straightforward task. With ROM validators you can specify validation rules just like in ActiveModel, with the addition of support for nested data structures:

```generic
class Validator
  include ROM::Model::Validator

  validates :author_name, :author_email, presence: true

  embedded :books do
    validates :title, :publication_date, presence: true
  end
end

validator = Validator.new(preprocessed_input[0])

puts validator.valid? # => true

```

If any of the books turn out to be invalid, you will get a nested `ActiveModel::Errors` object, under the same index as the book.

```generic
validator = Validator.new(author_name: "", books: [{ title: "" }])

validator.valid? # => false

validator.errors
# #<ActiveModel::Errors:0x007ff5f42e20d8 @base=#<Validator attributes={:author_name=>"", :books=>[{:title=>""}]} errors=#<ActiveModel::Errors:0x007ff5f42e20d8 ...>>, @messages={:author_uid=>["can't be blank"],
:author_name=>["can't be blank"], :author_email=>["can't be blank"], :books=>[#<ActiveModel::Errors:0x007ff5f44081d8 @base=#<#<Class:0x007ff5f43715d0> attributes={:title=>""} errors=#<ActiveModel::Errors:0x00
7ff5f44081d8 ...>>, @messages={:title=>["can't be blank"], :publication_date=>["can't be blank"]}>]}>

```

## Data Processor

The final data transformation step will turn our preprocessed and validated data structure into something that will match our database schema:

```generic
class Processor < ROM::Mapper
  attribute :code, from: :author_uid
  attribute :name, from: :author_name
  attribute :email, from: :author_email

  embedded :books, type: :array do
    attribute :title
    attribute :published_on, from: :publication_date, type: :date
  end
end

processor = Processor.build

puts processor.call(preprocessed_input).inspect
# => [{:authors=>{:name=>"Jane Doe", :email=>"jane@doe.org", :books=>[{:title=>"First", :published_on=>#<Date: 2010-10-10 ((2455480j,0s,0n),+0s,2299161j)>}, {:title=>"Second", :published_on=>#<Date: 2011-11-11 ((2455877j,0s,0n),+0s,2299161j)>}, {:title=>"Third", :published_on=>#<Date: 2012-12-12 ((2456274j,0s,0n),+0s,2299161j)>}]}}]

```

With the mapper DSL, we configure a couple of mappings so that the original input will be turned into something that we can easily persist. Notice that we are maintaining the nested structure, where `:books` is a nested array for each author. You’ll see why in the last step :)

Mapper DSL is very powerful - check out [the guides](http://rom-rb.org/guides/basics/mappers) if you want to learn more.

## Lazy-evaluation of Missing Information

One interesting pattern I discovered is that you can easily define lazy-values in the input data using the mapper, then inject specific evaluators when you have needed information in place - this reduced complexity of the code significantly; and surprisingly, it’s really simple.

We’re going to tweak our mapper to map `:author_uid` to a lazy-evaluable lambda that holds a reference to the original value and call it `:code`:

```generic
class Processor < ROM::Mapper
  attribute :code, from: :author_uid do |value|
    -> evaluator { evaluator[value] }
  end

  attribute :name, from: :author_name
  attribute :email, from: :author_email

  embedded :books, type: :array do
    attribute :title
    attribute :published_on, from: :publication_date, type: :date
  end
end

processor = Processor.build

processed_input = processo.call(preprocessed_input)

processed_input
# => [{:code=>#<Proc:0x007fc52b25e8b8@samples/dataimport.rb:80 (lambda)>, :name=>"Jane Doe", :email=>"jane@doe.org", :books=>[{:title=>"First", :published_on=>#<Date: 2010-10-10 ((2455480j,0s,0n),+0s,2299161j)>}, {:title=>"Second", :published_on=>#<Date: 2011-11-11 ((2455877j,0s,0n),+0s,2299161j)>}, {:title=>"Third", :published_on=>#<Date: 2012-12-12 ((2456274j,0s,0n),+0s,2299161j)>}]}]

```

Let’s focus on the lazy-evaluable `:code` - we configured it to be a lambda that captured the original value and allows it to receive some evaluator object. This makes the mapper unaware of any domain-specific details how the code will be fetched, we simply rely on `evaluator#[]` interface.

Later on we can evaluate it easily using [Transproc](https://github.com/solnic/transproc)’s `:eval_values` function:

```generic
module InputFunctions
  extend Transproc::Registry

  import :eval_values, from: Transproc::HashTransformations
end

# for the sake of simplicity, let's just use a hash:
author_code_map = { 'jd' => 'jd001' }

# grab the function with our evaluator-hash injected in
evaluate_code = InputFunctions[:eval_values, [author_code_map]]

evaluated_authors = processeded_input.map { |author| evaluate_code.call(author) }

evaluated_authors
# => [{:code=>"jd001", :name=>"Jane Doe", :email=>"jane@doe.org", :books=>[{:title=>"First", :published_on=>#<Date: 2010-10-10 ((2455480j,0s,0n),+0s,2299161j)>}, {:title=>"Second", :published_on=>#<Date: 2011-11-11 ((2455877j,0s,0n),+0s,2299161j)>}, {:title=>"Third", :published_on=>#<Date: 2012-12-12 ((2456274j,0s,0n),+0s,2299161j)>}]}]

```

That’s it - we’ve got external `:author_uid` mapped to our internal `:code`. Notice that you can inject anything as the evaluator and for complex scenarios you can have an evaluator that locates another object and delegate to it. This works really well and reduces the coupling to the minimum. The `:eval_values` function supports injecting multiple evaluators too and you can provide an optional array with attribute names that should be evaluated as a filter.

## Persisting Prepared Data Using ROM Commands

ROM commands can be combined together to persist a nested data structure. Think of it as a `nested_attributes_for` support, but in ROM.

Here’s how we could define them for our authors and their books:

```generic
ROM.setup(:sql, 'postgres://localhost/rom')

class CreateAuthor < ROM::Commands::Create[:sql]
  class Attributes
    include ROM::Model::Attributes

    attribute :code
    attribute :name
    attribute :email
  end

  relation :authors
  register_as :create

  input Attributes
end

class CreateBook < ROM::Commands::Create[:sql]
  class Attributes
    include ROM::Model::Attributes

    attribute :author_id
    attribute :title
    attribute :published_on
  end

  relation :books
  register_as :create
  associates :author, key: [:author_id, :id]

  input Attributes
end

rom = ROM.finalize.env

```

Having those commands defined, we can combine them in a way that will allow us to persist entire input in a single call:

```generic
create_authors_with_books = rom.command([
  :authors, [:create, [:books, [:create]]]
])

create_authors_with_books.call(authors: evaluated_authors)
# {:id=>1, :code=>"jd001", :name=>"Jane Doe", :email=>"jane@doe.org"}
# {:id=>1, :author_id=>1, :title=>"First", :published_on=>#<Date: 2010-10-10 ((2455480j,0s,0n),+0s,2299161j)>}
# {:id=>2, :author_id=>1, :title=>"Second", :published_on=>#<Date: 2011-11-11 ((2455877j,0s,0n),+0s,2299161j)>}
# {:id=>3, :author_id=>1, :title=>"Third", :published_on=>#<Date: 2012-12-12 ((2456274j,0s,0n),+0s,2299161j)>}

```

### Putting It All Together

With those 4 components in place, we can implement a simple procedure that will import the data:

```generic
preprocessor = Preprocessor.build

processor = Processor.build

evaluator = InputFunctions[:eval_values, [{ 'jd' => 'jd001' }]]

create_authors_with_books = rom.command([
  :authors, [:create, [:books, [:create]]]
])

preprocess = -> input { preprocessor.call(input) }

validate = -> input do
  if input.all? { |author| Validator.new(author).valid? }
    input
  end
end

process = -> input do
  processor.call(input).map { |author| evaluator.call(author) } if input
end

persist = -> input do
  create_authors_with_books.call(authors: input) if input
end

# now if we only could have proc composition in ruby... :)

result = persist[process[validate[preprocess[raw_input]]]]

result
# {:id=>1, :code=>"jd001", :name=>"Jane Doe", :email=>"jane@doe.org"}
# {:id=>1, :author_id=>1, :title=>"First", :published_on=>#<Date: 2010-10-10 ((2455480j,0s,0n),+0s,2299161j)>}
# {:id=>2, :author_id=>1, :title=>"Second", :published_on=>#<Date: 2011-11-11 ((2455877j,0s,0n),+0s,2299161j)>}
# {:id=>3, :author_id=>1, :title=>"Third", :published_on=>#<Date: 2012-12-12 ((2456274j,0s,0n),+0s,2299161j)>}

```

This procedure can, and should, be wrapped up in a couple of objects with proper error handling and any additional logic that might be required. I used simple procs to show the essential functionality and the order in which individual components are being called.

### Remarks

The process described here might not be a typical way of writing Ruby code. It’s probably slightly more functional than you are used to. What I discovered though is that being so explicit about data transformations, and the structure of the data while respecting the boundaries, results in a much simpler code.

A couple of general remarks:

- Testing individual components is ridiculously simple and in tests for the main orchestration you can easily mock the components
- Persistence logic can be split into separate steps too depending on the requirements
- Your database is your best friend - don’t forget about proper foreign-key constraints, not null constraints etc.
- `ROM::Model::*` components are currently part of rom-rails which is obviously not optimal - in the near future a new gem should emerge that will include them
- `ROM::Mapper` DSL could be extended with the support for adding new keys to tuples, it’s been discussed a couple of times but no final decision has been made yet
- `ROM::Model::Validator` is based on AM which has an API that doesn’t really fit here, see `Validator.new(state).valid?` + it’s mutable - we need a better validation library!
- There’s potential here to build a gem that is a dedicated data-import tool based on ROM
- This thing is bloody fast o/

* * *

Big thanks to [Andy Holland](https://github.com/AMHOL), [Andrew Kozin](https://github.com/nepalez), [Chris Flipse](https://github.com/cflipse), [Jeffrey Horn](https://github.com/jrhorn424), [Gregory Brown](https://github.com/practicingruby) and [Srdjan Pejic](https://github.com/batasrki) for reviewing this post <3
