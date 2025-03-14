---
title: "Announcing TextParser for Elixir"
date: 2025-03-14T12:05:21+01:00
tags:
- elixir
- opensource
- announcement
slug: announcing-textparser-for-elixir
---

I'm excited to announce the initial release of TextParser, a new Elixir library for extracting and validating structured tokens from text. Whether you need to parse URLs, hashtags, mentions, or custom patterns, TextParser provides a flexible and extensible solution.

## Why TextParser?

TextParser was born from real-world needs at [justcrosspost.app](https://justcrosspost.app), where processing tags, mentions, and URLs for Bluesky required precise handling of text tokens. The library has been designed with several key features in mind:

- **Accurate Position Tracking**: Each extracted token includes exact byte positions in the original text
- **Built-in Token Types**: Ready-to-use parsers for URLs, hashtags, and @-mentions
- **Custom Token Support**: Easy creation of custom token extractors
- **Validation Rules**: Flexible token validation through pattern matching and custom rules
- **Unicode Support**: Proper handling of emoji and other Unicode characters

## Quick Start

Add TextParser to your project's dependencies:

```elixir
def deps do
  [
    {:text_parser, "~> 0.1"}
  ]
end
```

Basic usage is straightforward:

```elixir
text = "Check out https://elixir-lang.org #elixir"
result = TextParser.parse(text)

# Extract URLs
urls = TextParser.get(result, TextParser.Tokens.URL)
# => [%TextParser.Tokens.URL{value: "https://elixir-lang.org", position: {10, 32}}]

# Extract hashtags
tags = TextParser.get(result, TextParser.Tokens.Tag)
# => [%TextParser.Tokens.Tag{value: "#elixir", position: {33, 40}}]
```

## Custom Token Types

One of TextParser's strengths is its extensibility. Here's an example of a custom token for extracting ISO 8601 dates:

```elixir
defmodule MyParser.Tokens.Date do
  use TextParser.Token,
    pattern: ~r/(?:^|\s)(\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01]))/,
    trim_chars: [",", ".", "!", "?"]

  def is_valid?(date_text) when is_binary(date_text) do
    case Date.from_iso8601(date_text) do
      {:ok, _date} -> true
      _ -> false
    end
  end
end

# Usage
text = "Meeting on 2024-01-15, party on 2024-12-31!"
result = TextParser.parse(text, extract: [MyParser.Tokens.Date])
```

## Custom Validation Rules

Need custom validation? TextParser provides a behaviour that you can use to implement your own validation rules:

```elixir
defmodule BlueskyParser do
  use TextParser

  def validate(%TextParser.Tokens.Tag{value: value} = tag) do
    if String.length(value) >= 66,
      do: {:error, "tag too long"},
      else: {:ok, tag}
  end
end
```

## What's Next?

This initial release provides a solid foundation for text token extraction, but this is just a good start 🙂 Here some things I'm planning to work on next:

- Additional built-in token types
- Integration with NimbleParsec for simpler and more composable extraction rules
- Integration guides for popular frameworks
- Removal of a couple of bluesky-specific pieces in Tag handling

## Get Started

- GitHub: [https://github.com/solnic/text_parser](https://github.com/solnic/text_parser)
- Documentation: [https://hexdocs.pm/text_parser](https://hexdocs.pm/text_parser)
- Issues & Feature Requests: [GitHub Issues](https://github.com/solnic/text_parser/issues)

Contributions and feedback are welcome! Whether you find a bug, have a feature request, or want to contribute code, please feel free to get involved.
