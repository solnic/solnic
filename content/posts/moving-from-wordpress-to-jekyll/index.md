---
title: Moving from WordPress to Jekyll
date: '2011-01-05'
categories:
- blog
tags:
- archives
- blog
- ruby
slug: moving-from-wordpress-to-jekyll
aliases:
- "/2011/01/05/moving-from-wordpress-to-jekyll"
- "/moving-from-wordpress-to-jekyll"
---

Hello World! As usual it’s been a while since I wrote anything here. Just wanted to say that I’m moving the site from WordPress to Jekyll and I like to share what I have learned so far. If you are considering a migration too here are the steps I have taken in order to port most of the tiny content of my blog. Read on and let me know if something can be done in a better (or even completely different) way.

## Posts migration

I followed [the instruction](https://github.com/mojombo/jekyll/wiki/Blog-Migrations/) on the official Jekyll wiki. It worked without any troubles. I only had to manually change file extensions from “html” to “textile”, since that’s what I was using with WordPress to format my posts. Generated post files have [YAML fronts](https://github.com/mojombo/jekyll/wiki/YAML-Front-Matter) with additional information taken from WordPress, specifically post ids and permalinks.

## Nginx setup

I had to make sure that old urls from WordPress will redirect correctly to the new ones. Fortunatelly it’s easy to do that with Nginx, here’s my config:

```generic
server {
  listen 80;
  servername solnic.codes www.solnic.codes;
  accesslog /var/log/nginx/solnic.codes.log;
  root /var/www/solnic.codes/_site;

location / {
    rewrite ^/(d+)/(d+)/(d+)/([a-z-d]+)$ /$1/$2/$3/$4.html permanent;
  }
}
```

This makes sure that urls with format “/year/month/day/post-title” will be
redirected to “/year/month/day/post-title.html”. I didn’t take care of
categories and tags urls, but it would be as easy to handle as in case of post
permalinks.

Setting up Jekyll

This was (actually still is as I haven’t finished) also a straightfoward task.
There is a nice overview on the
wiki that describes the basics you need to know about Jekyll.
Configuration has
defaults that work for me except pygments that I use for code highlighting which
is turned off by default. Every additional setting that you add to _config.yml
will be available via “site” object in your templates, so it’s handy
to configure at least your site’s url.

Layouts

In Jekyll you can easily nest layouts. I use 4 layouts, where “default” is
the base one:


default
page


this is used for “static” pages, like About, Contact etc.


post -
used by blog posts
tag -
used by “tag” pages which show all posts tagged with a given tag


Posts

Index page displays a list of post excerpts. With Jekyll you can include
“partial” templates by adding them to _includes folder. Here’s how you can use
it, given you have “_includes/excerpt.html” in your project:
—
layout: default
title: Home
—

<ul class="posts">
  {% for post in site.posts limit: 15 %}
  <li>
    {% include excerpt.html %}
  </li>
  {% endfor %}
</ul>


where excerpt.html could look like this:
<article class="excerpt">
  <header>
    <h2>
      <time pubdate datetime="{{ post.date | date_to_xmlschema }}">
        {{ post.date | date_to_string }}
      </time>
      »
      <a href="{{ post.url }}">{{ post.title }}</a>
    </h2>
  </header>
  {{ post.content | truncatewords:80 }}
</article>


Tags

I had troubles using categories with Jekyll so after all I decided to just use
tags. You can tag a post with YAML front:
—
title: My Post
tags:
  - foo
  - bar
—

post content


Then all the tags will be accessible via site object in your templates. For
example you can list your tags along with post counts like that:
<ul>
  {% for tag_data in site.tags %}
    <li>
      {{ tag_data[0] }} ({{ tag_data[1].size }})
    </li>
  {% endfor %}
</ul>


I put pages that list tagged posts in “tags” folder which makes them accessible
via “/tags/some-tag.html” urls.
I still need to write a rake task which dynamically generates these templates.
Rake task is done and it looks like that:
namespace "tags" do
  desc "Generate tag pages"
  task :generate_pages do
    folder = "tags"

    site.tags.each do |tag, posts|
      tag_page = "#{folder}/#{tag}.html"

      File.open(tag_page, ‘w’) do |file|
        file.write <<-EOS
—
layout: tag
title: solnic.codes / tags / #{tag}
name: #{tag}
—

<ul class="posts">

</ul>
        EOS
      end
    end
  end
end


Code highlighting

I use Pygments to highlight code snippets. Installation
instruction for various platforms is also on the wiki.
Once you got it installed you will need to generate CSS:

pygmentize -f html -S default > pygments.css
```

Where “default” is the name of a pygment theme. Here are available built-in pygments
themes:


autumn
borland
bw
colorful
default
emacs
friendly
fruity
manni
monokai
murphy
native
pastie
perldoc
tango
trac
vs


To learn more about Pygments you can check out the docs.

In order to highlight a code sample in your post you just wrap everything in a
liquid “highlight” block providing language name as an argument. Check out the
 list of all languages supported by
Pygments, pretty impressive, BrainFuck included :). For instance if you want to
highlight a ruby snippet you do this:

{% codeblock sample.rb %}
puts "Hello World!"
{% endcodeblock %}
```

Comments - importing to Disqus

This is still a work in progress. You can export entire content of your
WordPress blog to a special XML feed called “WordPress eXtended RSS”. Then you
upload this file via Disqus’ import tool. There is also another way, you can
use Disqus WordPress plugin to do the import automatically. Unfortunately neither
of these methods worked for me. It seems like the generated file is corrupted,
but the data are there so I will have to manually parse it and generate a new
import XML file. YAY…!

Resources

Here are some related links that you may find useful:


“Let It Go - Moving From Mephisto To
Jekyll” - an awesome post by Ken Collins, my biggest inspiration to do the migration too
“Rakefile for Jekyll site management” - a good start if you want to write some convenient rake tasks
“Liquid For Designers” docs - I’ve found it useful because I didn’t remember liquid syntax :)
Official Jekyll Wiki on Github
Markdown Syntax Docs
Pygments Documentation
Google Font Directory - I discovered that
while doing the migration. I use Ubuntu and Droid Sans Mono fonts.
Sources of this site on Github



$(‘code’).each(function() {
  $(this).html(this.innerHTML.replace(/{/g, "{"));
  $(this).html(this.innerHTML.replace(/}/g, "}"));
  $(this).html(this.innerHTML.replace(/%/g, "%"));
});

�
```
