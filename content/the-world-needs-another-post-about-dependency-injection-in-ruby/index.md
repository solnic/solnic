---
title: The World Needs Another Post About Dependency Injection in Ruby
date: '2013-12-17'
categories:
- blog
tags:
- archives
- blog
- di
- patterns
- ruby
slug: the-world-needs-another-post-about-dependency-injection-in-ruby
aliases:
- "/2013/12/17/the-world-needs-another-post-about-dependency-injection-in-ruby"
---

I was wondering what do we, rubyists, think about dependency injection these days as I remember some discussions about it which were mostly lots of post-java-trauma type of criticism. I had this blog post in the back of my head for a long time but knowing that this subject was sort of…explored already, I decided to see what google has to say before writing it. So I typed “ruby dependency injection” and got this:

![](/assets/images/di-ruby-google-results.png)

I jumped to DHH’s blog and re-read his article as I only had a vague memory of it. And that’s when I realized the world needs another post about dependency injection in Ruby. Why? Mostly because there’s a risk a lot of rubyists out there have an incorrect perception of what DI in Ruby actually is. Also people who want to learn what it is might find DHH’s blog post which really gives a terribly wrong impression that DI in Ruby is “not needed”. Yes, really, this worries me.

Did you notice that I wrote “DI in Ruby”. The “in Ruby” part is quite important as DI **in Ruby** is a pretty straight-forward practice which comes with a bunch of benefits.

Oh and let’s make it clear:

You don’t need any extra libraries to use DI in Ruby.

You don’t need to configure anything to use DI in Ruby.

You don’t need to sacrifice code simplicity to use DI in Ruby.

You don’t need to write more code to use DI in Ruby.

## DI in Ruby is dead-simple

Nothing fancy here, really, but the impact it has on your code is significant. When you inject dependencies into objects rather than having objects creating their dependencies you get more flexibility and less coupling. The ease of testing is just a nice side-effect of a better design. Which is usually the case.

OK here it goes:

```generic
# a typical approach
class Hacker

  def initialize
    @keyboard = Keyboard.new(:layout => 'us')
  end

  # stuff
end

# and now with DI
class Hacker

  def initialize(keyboard)
    @keyboard = keyboard
  end

  # stuff
end

```

Did we use some fancy DI libraries? Nope. Did we write more code? Not really. Was it more complicated? Uhm, definitely not.

It’s a small change but the impact it has on your code **is significant**. Our Hacker is no longer coupled to the details of how to create a keyboard. It’s only going to use its interface and we are free to inject whatever we want as long as it implements keyboard interface. That’s called flexibility and less coupling.

OK great but where do we create that keyboard dependency? It has to be created somewhere, right?

Here’s a pattern I started using:

```generic
class Hacker

  def self.build(layout = 'us')
    new(Keyboard.new(:layout => layout))
  end

  def initialize(keyboard)
    @keyboard = keyboard
  end

  # stuff
end

```

Wait, I lied, that’s like 2 lines of extra code for the build method. OK you got me.

Look at the bright side though:

```generic
# we can create a hacker instance with very little effort
Hacker.build('us')

# there might be a case we already have a keyboard, that's gonna work too
Hacker.new(keyboard_we_already_had)

```

Since we’re pretty explicit about the dependencies it’s easier to test it:

```generic
describe Hacker do
  # let's say keyboard is a heavy dependency so we just want to mock it here
  let(:keyboard) { mock('keyboard') }

  it 'writes awesome ruby code' do
    hacker = Hacker.new(keyboard)

    # some expectations
  end
end

```

Think about how it would look like without DI. I wrote terrible things like that and I still see people writing terrible things like that:

```generic
describe Hacker do
  let(:keyboard) { mock('keyboard') }

  it 'writes awesome ruby code' do
    # YUCK!
    Keyboard.should_receive(:new).
      with(:layout => 'us').
      and_return(keyboard)

    hacker = Hacker.new

    # some expectations
  end
end

```

## It can go even further

When practicing DI in Ruby I’ve identified some smaller patterns and practices that I follow:

- Keep “.new” method clean, don’t override it, just make it accept the dependencies as arguments
- Have a separate builder method which can accept “ugly” input and create everything that your object needs to exist
- Extract building logic into a separate object when builder method gets too complex
- Avoid passing option hashes to the constructor

This has a very positive impact on the code I write. Lowers coupling, increases flexibility and makes refactoring simpler too.

As it’s usually the case it’s hard to convince that a given practice makes sense in a bunch of simple code examples in a blog post hence I really encourage you to just try using DI in Ruby. Just don’t assume it makes no sense because we can stub Time.now, please. Don’t :)

What I probably want to say is that dependency injection in Ruby is a virtue. Ruby is a beautiful language which allows doing clever things in a simple way. Stubbing Time.now is not very clever by the way. Sure, you can avoid using DI but it’s much cleaner and more explicit to actually use it. Your code will be better.
