---
title: Unobtrusive JavaScript helpers in Rails 3
date: '2009-09-08'
categories:
- blog
tags:
- archives
- blog
- javascript
- rails
slug: unobtrusive-javascript-helpers-in-rails-3
aliases:
- "/2009/09/08/unobtrusive-javascript-helpers-in-rails-3"
---

A while ago I have written a post about [JavaScript helpers in Ruby on Rails](http://blog.solnic.codes/2007/10/30/why-javascript-helpers-in-rails-are-evil) and tried to explain why they are a bad idea. It’s hard to believe for me that it was almost 2 years ago! Since then so many things have happened in the Ruby world…Now Rails 3 is on its way and we already know what significant improvements and changes it will include. One of them is related to JavaScript helpers and the way how remote links and forms will be handled and I must admit that the new idea is absolutely great.

The new way is based on unobtrusive approach to JavaScript. This means that HTML code will be separated from JavaScript. I have checked out the latest sources of Ruby on Rails and found out that some of the work is already done. There is a new helper called AjaxHelper, it implements link\_to\_remote method which in the moment of writing this post looks like this:

```generic
def link_to_remote(name, url, options = {})
  html = options.delete(:html) || {}

  update = options.delete(:update)
  if update.is_a?(Hash)
    html["data-update-success"] = update[:success]
    html["data-update-failure"] = update[:failure]
  else
    html["data-update-success"] = update
  end

  html["data-update-position"] = options.delete(:position)
  html["data-method"]          = options.delete(:method)
  html["data-remote"]          = "true"

  html.merge!(options)

  url = url_for(url) if url.is_a?(Hash)
  link_to(name, url, html)
end

```

What you see here will generate a clean markup with HTML5-compliant attributes prefixed with a word “data-”. If you are not familiar with them you can checkout a nice article by John Resig [HTML 5 data- Attributes](http://ejohn.org/blog/html-5-data-attributes). Those attributes will instruct the additional JavaScript code how it should handle the behavior. Basically all links, buttons and forms that have the special attribute “data-remote” set to “true” will issue an AJAX request. There has been a discussion on [the Rails on Rails Core group](http://www.mail-archive.com/rubyonrails-core@googlegroups.com/msg09122.html) about how to implement corresponding JavaScript code. People are worried about its performance since finding all elements with data-remote=true appears to be slow in case of Prototype and jQuery. Moreover there is a problem of new elements that may be dynamically inserted after the page was loaded and all the event listeners were attached. Fortunately there is no need to be worried as our situation is a perfect example where we should use [Event Delegation](http://www.sitepoint.com/blogs/2008/07/23/javascript-event-delegation-is-easier-than-you-think/). DHH has already showed in his [Rails 3 and the Real Secret to High Productivity](http://www.scribd.com/doc/15010095/Rails-3-and-the-Real-Secret-to-High-Productivity) presentation how links and buttons can be handled by [Prototype](http://www.prototypejs.org) library and it looks absolutely reasonable to me.

I would like to focus on jQuery though as it’s getting more popular even in the Rails community. Great example is [my job](http://www.lunarlogicpolska.com) where we use jQuery in every of our new projects. So how can we handle new remote links and forms using this popular library? Actually it’s ridiculously easy. Thanks to [jQuery.live](http://docs.jquery.com/Events/live) function we can easily use [Event Delegation](http://www.sitepoint.com/blogs/2008/07/23/javascript-event-delegation-is-easier-than-you-think) to handle AJAX calls. Just take a look at this sample of a markup that new helpers in Rails 3 will generate:

```generic
<!– the new link to remote –>
<a href="http://solnic.codes/users" data-remote="true">Users</a>

<!– the new remote form –>
<form action="/users" method="post" data-remote="true">
  <input type="text" name="login"/>
  <input type="submit"/>
</form>

```

Pretty clean, I really like it! Now let’s see how we can implement jQuery handler that will send AJAX requests:

```generic
var request = function(options) {
  $.ajax($.extend({ url : options.url, type : 'get' }, options));
  return false;
};

// remote links handler
$('a[data-remote=true]').live('click', function() {
  return request({ url : this.href });
});

// remote forms handler
$('form[data-remote=true]').live('submit', function() {
  return request({ url : this.action, type : this.method, data : $(this).serialize() });
});

```

The above code will send an AJAX request when you click on a remote link or submit a remote form. Note that it will work also with new elements dynamically inserted to the DOM. The example JavaScript code is the bare minimum of course, we could have something much more sophisticated. We will be able to specify success and failure handlers and also elements that should be updated with an AJAX response text (and probably much more!), hence the JavaScript is going to be more complicated.

This is definitely a step into the right direction. I’m looking forward to Rails 3!
