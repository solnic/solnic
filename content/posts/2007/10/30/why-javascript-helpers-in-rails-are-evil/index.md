---
title: "Why JavaScript helpers in rails are evil"
date: "2007-10-30"
categories: 
  - "blog"
tags: 
  - "blog"
  - "javascript"
  - "rails"
---

Ruby on Rails gained so much attention and appreciation mostly because it simplifies the development process of AJAX\-driven applications. When I started to learn Rails I was already very familiar with other MVC\-based frameworks, and actually I’ve created one myself (in PHP5) in my previous work. My framework also uses Prototype JavaScript library, so when l was learning Rails it was nothing new when I saw “Ajax.Updater(…)”. I remember that when I added first AJAX\-feature in the Depot (it’s a tutorial application used in well known “Agile Web Development in Ruby on Rails” book) **I was shocked** about how simple it is, but then I looked into the HTML output and it shocked me once more…

### JavaScript Helpers

These nice methods generate for you HTML with some addition of JavaScript code, one can say “You don’t need to know JavaScript to create AJAX web apps! Just use Ruby on Rails!”. It’s a catchy slogan, and in some way it’s true, you don’t need to know how Ajax.Request works, you just write link\_to\_remote and you’re done. In Rails API you can find 4 helper modules, all related to JavaScript code generation, and here they are:

- [General JavaScript Helpers](http://api.rubyonrails.org/classes/ActionView/Helpers/JavaScriptHelper.html) – actually there’s nothing interesting there
- [JavaScript Macros Helpers](http://api.rubyonrails.org/classes/ActionView/Helpers/JavaScriptMacrosHelper.html) – whole thing is deprecated in the upcoming Rails 2.0
- [Prototype Helpers](http://api.rubyonrails.org/classes/ActionView/Helpers/PrototypeHelper.html) – probably the most popular methods, including link\_to\_remote and other AJAX goodies
- [Scriptaculous Helpers](http://api.rubyonrails.org/classes/ActionView/Helpers/ScriptaculousHelper.html) – you know, drag’n’drop and visual effects goodies

When I first saw what link\_to\_remote helper creates I was really surprised, back then I said to myself “hey, that’s…just bad!”. Unfortunately I had quickly forgotten about my negative thoughts on JavaScript helpers, because “everybody” use them, and that’s a shame in my opinion. I don’t know why JavaScript helpers are included in the Rails core, maybe it was just a pure marketing trick or something :) So, what’s so evil about JavaScript helpers?

### DRY – ooooh reaaally?

We, the Ruby on Rails developers, use proudly our favorite MVC framework, we remember everyday about Don’t Repeat Yourself principle and other good and well known practices. How come that people like us write scary pieces of code like this:

```generic
&lt;table id="users_list"&gt;
  &lt;% @users.each do |user| -%&gt;
  &lt;tr id="user_&lt;%= user.id %&gt;"&gt;
    &lt;td&gt;&lt;%= user.login %&gt;&lt;/td&gt;
    &lt;td&gt;
      &lt;%= link_to_remote(
             ‘Delete’,
             :url =&gt; user_path(user),
             :method =&gt; ‘delete’,
             :confirm =&gt; ‘Are you sure?’,
             :complete =&gt; "Effect.DropOut(‘user_#{user.id}’)",
             :failure =&gt; ‘alert("Could not delete user: #{user.login}")’
          )
      %&gt;
    &lt;/td&gt;
  &lt;/tr&gt;
  &lt;% end -%&gt;
&lt;/table&gt;
  &lt;% end %&gt;
&lt;/table&gt;

```

Pretty common rhtml snippet, right?? (yes, I know, we use partials, but it’s just an example) Let’s have a look at the HTML output:

```generic
&lt;table id="users_list"&gt;
    &lt;tr id="user_2"&gt;
    &lt;td&gt;jane&lt;/td&gt;
    &lt;td&gt;
      &lt;a href="#" onclick="if (confirm(‘Are you sure?’)) { new Ajax.Request(‘/users/2’, {asynchronous:true, evalScripts:true, method: ‘delete’, onComplete:function(request){Effect.DropOut(‘user_2’)}, onFailure:function(request){alert(‘Could not delete user: jane’)}}); }; return false;"&gt;Delete&lt;/a&gt;
    &lt;/td&gt;
  &lt;/tr&gt;
    &lt;tr id="user_1"&gt;
    &lt;td&gt;john&lt;/td&gt;
    &lt;td&gt;
      &lt;a href="#" onclick="if (confirm(‘Are you sure?’)) { new Ajax.Request(‘/users/1’, {asynchronous:true, evalScripts:true, method: ‘delete’, onComplete:function(request){Effect.DropOut(‘user_1’)}, onFailure:function(request){alert(‘Could not delete user: john’)}}); }; return false;"&gt;Delete&lt;/a&gt;
    &lt;/td&gt;
  &lt;/tr&gt;
    &lt;tr id="user_4"&gt;
    &lt;td&gt;paul&lt;/td&gt;
    &lt;td&gt;
      &lt;a href="#" onclick="if (confirm(‘Are you sure?’)) { new Ajax.Request(‘/users/4’, {asynchronous:true, evalScripts:true, method: ‘delete’, onComplete:function(request){Effect.DropOut(‘user_4’)}, onFailure:function(request){alert(‘Could not delete user: paul’)}}); }; return false;"&gt;Delete&lt;/a&gt;
    &lt;/td&gt;
  &lt;/tr&gt;
    &lt;tr id="user_3"&gt;
    &lt;td&gt;peter&lt;/td&gt;
    &lt;td&gt;
      &lt;a href="#" onclick="if (confirm(‘Are you sure?’)) { new Ajax.Request(‘/users/3’, {asynchronous:true, evalScripts:true, method: ‘delete’, onComplete:function(request){Effect.DropOut(‘user_3’)}, onFailure:function(request){alert(‘Could not delete user: peter’)}}); }; return false;"&gt;Delete&lt;/a&gt;
    &lt;/td&gt;
  &lt;/tr&gt;
  &lt;/table&gt;

```

**Where did DRY go?** Hello? Why we don’t apply our OOP practices also to JavaScript? “Why bother!?” you might ask, well, BECAUSE IT MATTERS.

### JavaScript won’t hurt you

Creating webapps without a good understanding of JavaScript is like working with ActiveRecord and having no idea what SQL is. I think you know what I mean. There are plenty of great JavaScript libraries, Ruby on Rails comes with [Prototype](http://www.prototypejs.org) and it makes writing JavaScript as easy&cool as writing Ruby code. Okey, here’s above example without redundancy, the quickest solution would be:

```generic
&lt;table id="users_list"&gt;
  &lt;% @users.each do |user| -%&gt;
  &lt;tr id="user_&lt;%= user.id %&gt;"&gt;
    &lt;td&gt;&lt;%= user.login %&gt;&lt;/td&gt;
    &lt;td&gt;&lt;%= link_to ‘Delete’, ‘#’, :onclick =&gt; "deleteUser(#{user.id})" %&gt;&lt;/td&gt;
  &lt;/tr&gt;
  &lt;% end -%&gt;
&lt;/table&gt;

```

And in application.js (or wherever else):

```generic
function deleteUser(userId) {
  if(confirm(‘Are you sure?’) {
    new Ajax.Request(
       ‘/users/’+userId, {
         method : ‘delete’,
         on200 : function(){ Effect.DropOut(‘user_’+userId) },
         on500 : function(xhr){ alert(xhr.responseText) }
    });
  }
  return false;
}

```

Now, our ouput looks like this:

```generic
&lt;table id="users_list"&gt;
  &lt;tr&gt;
  &lt;tr id="user_2"&gt;
    &lt;td&gt;jane&lt;/td&gt;
    &lt;td&gt;&lt;a href="#" onclick="deleteUser(2)"&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
  &lt;tr id="user_1"&gt;
    &lt;td&gt;john&lt;/td&gt;
    &lt;td&gt;&lt;a href="#" onclick="deleteUser(1)"&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
  &lt;tr id="user_4"&gt;
    &lt;td&gt;paul&lt;/td&gt;
    &lt;td&gt;&lt;a href="#" onclick="deleteUser(4)"&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
  &lt;tr id="user_3"&gt;
    &lt;td&gt;peter&lt;/td&gt;
    &lt;td&gt;&lt;a href="#" onclick="deleteUser(3)"&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
&lt;/table&gt;

```

Advantages:

- We don’t have a redundant JavaScript code in the HTML output
- We are not limited to what link\_to\_remote generates
- We have a generic JavaScript function which deletes a user, we can make it even more generic and use successfully in other places

Disadvantages:

- Obtrusive JavaScript code in HTML

### Progressive enhancement and unobtrusive JavaScript

I found out about this approach about half a year ago, when I started to use Dan Webb’s UJS rails plugin which makes an extensive use of LowPro library. I was very excited about its functionality, thanks to that plugin I’ve stopped using JavaScript helpers. UJS is a dead project now, you can find out why [here](http://www.danwebb.net/2007/6/16/the-state-and-future-of-the-ujs-plugin) but it doesn’t matter, thanks to it I’ve learned two important things:

- We can divide View layer into two sub-layers: the presentation (HTML+CSS) and the behaviour (JavaScript)
- Presentation layer can be extended using JavaScript by adding various behaviours to the DOM elements

Currently I don’t use UJS or pure Low Pro, instead I just code my JavaScript using Prototype and Scriptaculous. Let’s see how this looks in practice. Here’s how our users table example could be implemented using progressive enhancement and unobtrusive JavaScript code. First of all, we’re going to create plain HTML links, without onclick event and without even href attribute (I assume we’re writing an application which requires JavaScript to work):

```generic
&lt;table id="users_list"&gt;
  &lt;% @users.each do |user| -%&gt;
  &lt;tr id="user_&lt;%= user.id %&gt;"&gt;
    &lt;td&gt;&lt;%= user.login %&gt;&lt;/td&gt;
    &lt;td&gt;&lt;a&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
  &lt;% end -%&gt;
&lt;/table&gt;

```

Above rhtml template generates this HTML output:

```generic
&lt;table id="users_list"&gt;
  &lt;tr id="user_3"&gt;
    &lt;td&gt;peter&lt;/td&gt;
    &lt;td&gt;&lt;a&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
  &lt;tr id="user_4"&gt;
    &lt;td&gt;paul&lt;/td&gt;
    &lt;td&gt;&lt;a&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
  &lt;tr id="user_1"&gt;
    &lt;td&gt;john&lt;/td&gt;
    &lt;td&gt;&lt;a&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
  &lt;tr id="user_2"&gt;
    &lt;td&gt;jane&lt;/td&gt;
    &lt;td&gt;&lt;a&gt;Delete&lt;/a&gt;&lt;/td&gt;
  &lt;/tr&gt;
&lt;/table&gt;

```

The very last thing to do is to add an actual functionality to our plain HTML code. Let’s create a simple module called Users, which will include method for deleting users:

```generic
var Users = {
  onWindowLoad : function() {
    $(‘users_list’).getElementsBySelector(‘tr’).each(function(userRow){
      userRow.down(‘a’).observe(‘click’, Users.onUserDelete);
    });
  },
  onUserDelete : function(event) {
    if(confirm(‘Are you sure?’)) {
      var userId = Event.element(event).up(‘tr’).id.split(‘_’).last();
      new Ajax.Request(
       ‘/users/’+userId, {
         method : ‘delete’,
         on200 : function(){ Effect.DropOut(‘user_’+userId) },
         on500 : function(xhr){ alert(xhr.responseText) }
      });
    }
  }
}
Event.observe(window, ‘load’, Users.onWindowLoad);

```

This way we:

- Write reusable and object oriented code
- Create clean and easy to maintain RHTML templates
- Have a clean separation between visual and behavior layers in our applications
- Decrease site loading time by writing less JavaScript (you can even [compress it](http://synthesis.sbecker.net/pages/asset_packager) too)
- Improve general performance of our application’s UI
- Learn JavaScript! :)

### The final word

I didn’t write anything about so called graceful degradation issue, leaving JavaScript helpers behind was the main reason for this article. If you totally disagree with me or/and you know an even better approach, leave a comment, I’m always open to a discussion.
