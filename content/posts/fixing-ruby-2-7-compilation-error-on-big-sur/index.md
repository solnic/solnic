---
title: Fixing Ruby 2.7 compilation error on Big Sur
date: '2020-12-09'
tags:
- archives
- ruby
- macos
- big-sur
categories:
- blog
slug: fixing-ruby-2-7-compilation-error-on-big-sur
aliases:
- "/2020/12/09/fixing-ruby-2-7-compilation-error-on-big-sur"
- "/fixing-ruby-2-7-compilation-error-on-big-sur"
---

We're in the process of upgrading to Ruby 2.7.2 at [castle.io](http://castle.io) and today I had to install it on macOS Big Sur. Unfortunately, I hit a compilation error that looked like this:

```generic
$ ruby-install ruby 2.7.2
# yada yada yada
compiling dmyext.c
translating probes probes.d
. ./vm_opts.h
compiling array.c
compiling ast.c
compiling bignum.c
compiling class.c
compiling compar.c
compiling compile.c
compile.c:9857:61: error: use of undeclared identifier 'RUBY_FUNCTION_NAME_STRING'
    if (table == NULL) rb_bug("%s: table is not provided.", RUBY_FUNCTION_NAME_STRING);
                                                            ^
compile.c:9859:63: error: use of undeclared identifier 'RUBY_FUNCTION_NAME_STRING'
        rb_bug("%s: index (%d) mismatch (expect %s but %s).", RUBY_FUNCTION_NAME_STRING, i, name, table[i].name);
                                                              ^
2 errors generated.
make: *** [compile.o] Error 1
!!! Compiling ruby 2.7.2 failed!
```

After some digging I managed to solve this problem by doing the following:

```generic
brew update
brew upgrade
brew install llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
```

After upgrading all the dependencies and installing llvm via Homebrew, I finally ran [ruby-install](https://github.com/postmodern/ruby-install) command with no errors:

```generic
$ ruby-install ruby 2.7.2
# yada yada yada
>>> Successfully installed ruby 2.7.2 into /Users/solnic/.rubies/ruby-2.7.2
```

This is cool and I'm happy - I can finally use [pattern matching](https://www.toptal.com/ruby/ruby-pattern-matching-tutorial) at work!
