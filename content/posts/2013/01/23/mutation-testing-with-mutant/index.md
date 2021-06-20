---
title: "Mutation testing with Mutant"
date: "2013-01-23"
categories: 
  - "blog"
tags: 
  - "blog"
  - "mutation-testing"
  - "ruby"
  - "tdd"
---

When working on [DataMapper](https://github.com/datamapper) and its libraries we put a lot of effort into testing. Our libraries must have 100% code coverage and even that is not enough. What we want to achieve eventually is full mutation coverage. What is that? If you’ve ever heard or used [Heckle](https://github.com/seattlerb/heckle) then you’re probably familiar with the concept and you can skip the first part of this post and read about mutant.

## Code Coverage vs Mutation Coverage

If your library has 100% code coverage and you think you did a great job then I have some bad news for you. You did a decent job but there’s a big risk you missed a lot while writing your tests and there are bugs that sooner or later users of your library will discover. Sometimes it’s not a big tragedy, you’ll get a bug report, you’ll fix the bug and everybody’s happy. On the other hand there’s a risk your code base is big enough that bugs that are found too late might be really difficult to fix. This can even require a bigger refactoring just to fix something. That’s one of the reasons why mutation testing can you help you in catching bugs early enough and making sure your code is going in a good direction.

Let me demonstrate what I’m talking about with a simple code example. Consider this:

```generic
class Page < Struct.new(:number, :content)
end

class Book
  attr_reader :pages

  def initialize
    @pages = []
    @index = {}
  end

  def page(number)
    @index.fetch(number) {
      raise "Book does not have a page with number: #{number}"
    }
  end

  def add_page(page)
    @pages << page
    @index[page.number] = page
    self
  end
end

```

This is pretty simple. We have a book and we can add pages to it via #add_page method. Let’s take a look how a test for Book#add_page could be written:

```generic
describe Book, '#add_page' do
  subject(:book) { Book.new }

  let(:page)     { Page.new(1) }

  it 'should return self' do
    expect(book.add_page(page)).to be(book)
  end

  it 'should add page to book' do
    book.add_page(page)
    expect(book.pages).to include(page)
  end
end

```

If you measure code coverage it will report 100%. WOW! So cool! It’s working and has 100% code coverage!

## Introducing Mutant (and how it can ruin your enthusiasm)

OK so I’m very proud of my Book class and the test. It’s passing, it’s covered in 100%, awesome. Let’s see what mutant has to say about it:

```generic
$ mutant -I lib -r book --use rspec '::Book#add_page'

Mutant configuration:
Matcher:         #<Mutant::Matcher::Method::Instance cache=#<Mutant::Cache> scope=Book method=#<UnboundMethod: Book#add_page>>
Strategy:        #<Mutant::Rspec::Strategy>
Expect Coverage: 100.000000%
Book#add_page:/Users/solnic/Workspace/mutant-examples/lib/book.rb:18
.....F.FFF...F.....
(14/19)  73% - 1.30s
Book#add_page:/Users/solnic/Workspace/mutant-examples/lib/book.rb:18
evil:Book#add_page:/Users/solnic/Workspace/mutant-examples/lib/book.rb:18:fd55d
@@ -1,6 +1,6 @@
 def add_page(page)
- @pages << page
+  @pages
   @index[page.number] = page
   self
 end
evil:Book#add_page:/Users/solnic/Workspace/mutant-examples/lib/book.rb:18:cf59d
@@ -1,6 +1,6 @@
 def add_page(page)
- @pages << page
+  page
   @index[page.number] = page
   self
 end
evil:Book#add_page:/Users/solnic/Workspace/mutant-examples/lib/book.rb:18:3f9b5
@@ -1,6 +1,6 @@
 def add_page(page)
- @pages << page
+  @pages << nil
   @index[page.number] = page
   self
 end
evil:Book#add_page:/Users/solnic/Workspace/mutant-examples/lib/book.rb:18:ffd81
@@ -1,6 +1,6 @@
 def add_page(page)
- @pages << page
+  nil
   @index[page.number] = page
   self
 end
evil:Book#add_page:/Users/solnic/Workspace/mutant-examples/lib/book.rb:18:52a4a
@@ -1,6 +1,5 @@
 def add_page(page)
- @pages << page
   @index[page.number] = page
   self
 end
(14/19)  73% - 1.30s
Subjects:  1
Mutations: 19
Kills:     14
Alive:     5
Runtime:   1.37s
Killtime:  1.30s
Overhead:  5.13%
Coverage:  73.68%
Expected:  100.00%

```

Let me explain what just happened. Mutant changes your code at run-time then runs your tests expecting them **to fail**. That’s basically mutation testing. Look at the diff in the output - it shows that mutant removed the line where page is stored in the index with its number. The test passes because we didn’t cover that at all. Remember that code coverage reports 100% because this line is executed when running tests but there is no test which verifies **behavior** in 100%. In this case we should have a test that checks if the page was also added to the index.

Let’s fix that by adding another example to our test:

```generic
describe Book do
  subject(:book) { Book.new }

  let(:page) { Page.new(1) }

  describe '#page' do
    before { book.add_page(page) }

    context 'when page exists' do
      it 'should return page' do
        expect(book.page(1)).to be(page)
      end
    end

    context 'when page does not exist' do
      it 'should raise error' do
        expect { book.page(2) }.to raise_error(
          RuntimeError, "Book does not have a page with number: 2"
        )
      end
    end
  end

  describe '#add_page' do
    it 'should return self' do
      expect(book.add_page(page)).to be(book)
    end

    it 'should add page to book' do
      book.add_page(page)
      expect(book.pages).to include(page)
    end

    it 'should add page to book index' do
      book.add_page(page)
      expect(book.index).to include(1 => page)
    end
  end
end

```

We simply added a new example checking if page was actually added to the index because that’s what the method does. Now let’s run mutant again!

```generic
$ mutant -I lib -r book --use rspec '::Book#add_page'

Mutant configuration:
Matcher:         #<Mutant::Matcher::Method::Instance cache=#<Mutant::Cache> scope=Book method=#<UnboundMethod: Book#add_page>>
Strategy:        #<Mutant::Rspec::Strategy>
Expect Coverage: 100.000000%
Book#add_page:/Users/solnic/Workspace/mutant-examples/lib/book.rb:18
...................
(19/19) 100% - 1.39s
Subjects:  1
Mutations: 19
Kills:     19
Alive:     0
Runtime:   1.46s
Killtime:  1.39s
Overhead:  4.81%
Coverage:  100.00%
Expected:  100.00%

```

Now it’s time to relax because we really covered everything. The output says that mutant performed 8 mutations and every mutation caused a test failure.

## Can I use it now?

Yes! Yes you can. I made a repo on github with the example from this post [here](https://github.com/solnic/mutant-examples). See its README for more information. You need Ruby >=1.9 or Rubinius for mutant to work.

Huge props go to [Markus Schirp](https://github.com/mbj) for his fantastic work on [Mutant](https://github.com/mbj/mutant) and helping me in writing this post.

I hope you’re feeling convinced that mutation testing is great!
