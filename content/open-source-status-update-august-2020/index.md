---
title: Open Source Status Update - August 2020
date: '2020-09-04'
categories:
- blog
tags:
- archives
- dry-rb
- oss
slug: open-source-status-update-august-2020
aliases:
- "/2020/09/04/open-source-status-update-august-2020"
---

Hey y'all! It's time for another OSS update. I was quite busy with my "normal work" in August so unfortunately I didn't manage to work on rom-rb like I planned. I focused mostly on dry-rb maintenance work and growing my YouTube channel.

OK let's see what happened!

## Saying "good bye" to dry-web!

That's right! We officially discontinued our work on dry-web as well as dry-web-roda, which was its companion gem that integrated Roda with dry-web.

The reason is quite simple - we're focusing our efforts on Hanami 2.0 and there's no real need to continue maintaining dry-web and dry-web-roda. If you've got apps running on dry-web-roda, don't worry - transitioning to Hanami 2.0 shouldn't be hard!

For me, this was "an end of an era" type of a moment. I know that dry-web was a really niche project but I believe it paved the way to many great things. I bet many of you, even if you've been following dry-rb evolution, don't know that dry-web and dry-web-roda started as my "crazy" idea called [rodakase](https://github.com/solnic/rodakase) - this is where initial ideas behind dry-web, dry-view and also dry-system were born. I'll cover this story in detail in a "dry-web - why?" episode on YouTube at some point.

## dry-validation 1.5.4

Thanks to [tadeusz-niemiec](https://github.com/tadeusz-niemiec) contribution dry-validation was improved and now you can use `key?` rule helper with any key name or path as an optional argument.

Here's a simple example where we check presence of two keys:

```ruby
class DistanceContract < Dry::Validation::Contract
  schema do
    optional(:kilometers).value(:integer)
    optional(:miles).value(:integer)
  end

  rule(:kilometers, :miles) do
    if key?(:kilometers) && key?(:miles)
      base.failure("must only contain one of: kilometers, miles")
    end
  end
end
```

## dry-schema 1.5.3

This bug fix release addressed an issue with "key validator" and "maybe hashes", thanks to contributions from (again!) [tadeusz-niemiec](https://github.com/tadeusz-niemiec) and [svobom57](http://svobom57).

In dry-schema you can define "maybe" values, which means that a given value could be `nil`. Now, "key validator" is an optional type of validation that you can enable, and when you do that, schema will also look for unexpected keys. The bug we had caused "maybe hashes" to produce "unexpected keys" errors when values are `nil`.

Now since `1.5.3` this use case works as expected:

```generic
schema = Dry::Schema.Params do
  required(:locations).array(:hash) do
    required(:feedback_location).maybe(:hash) do
      required(:lat).filled(:float)
      required(:lon).filled(:float)
    end
  end
end

schema.call({ locations: [{ feedback_location: nil }] }).errors.to_h
# {}
```

## dry-logic 1.0.7

Our rule and predicate logic backend used by dry-schema and dry-types got a new set of predicates for checking various versions of the UUID standard. Thanks to a contribution from [jamesbrauman](https://github.com/jamesbrauman) you can now use `uuid_v1?`, `uuid_v2?`, `uuid_v3?` and `uuid_v5?` predicates!

This also means you can use it in dry-schema, but for now you would have to add corresponding error messages because at the moment, the builtin errors only support [uuid\_v4](https://github.com/dry-rb/dry-schema/blob/9fa02a6efbc967c2c932c2dfae9de30ecde30a41/config/errors.yml#L106).

## "dry-validation - why?" screencast

I started a new series of screencasts where I'm explaining the motivation behind dry-rb libraries. [I started with dry-validation](https://www.youtube.com/watch?v=nOUPIa7tWpA) and to my honest surprise the screencast was featured in [RubyWeekly #515](https://rubyweekly.com/issues/515) at the very top of the list! So far it's got 2.5k views and the response has been very, very positive, thank you so, so much! ❤

I managed to make a follow-up screencast about [dry-types and dry-struct](https://www.youtube.com/watch?v=eTrOeTiLZGk) that got recently published and so far the response has been also very positive!

## What's next?

OK that wraps up todays update. My plan for this month is the same as last month, which is to go back to working on rom-rb. I'll be also recording more dry-rb screencasts in the "why?" series, so stay tuned!

I hope y'all stay safe and healthy!
