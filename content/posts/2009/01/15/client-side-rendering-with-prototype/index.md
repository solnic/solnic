---
title: "Client-side rendering with Prototype"
date: "2009-01-15"
categories: 
  - "blog"
tags: 
  - "blog"
  - "javascript"
---

Web applications are getting more and more complex. The user interface of a modern web application can be as rich as its desktop equivalent. If we use JavaScript/HTML/CSS trio to build this UI then we definitely want to use AJAX. A typical approach is to use AJAX to update parts of our page using an HTML response, everyone knows that, right? Does this approach allow us to create a responsive, fast and flexible UI? The answer is no.

Here are 4 main downsides of using AJAX requests to load UI parts:

- You increase the server load – yes, you make an AJAX request only because you need a piece of HTML code that you want to insert to an already rendered page. That was cool a few years ago when AJAX was such a great innovation. Nowadays it should be considered as a less efficient solution.

- You complicate the server-side code – because you need parts of your page to be returned by the server you, obviously, need to handle that by writing more server-side code. You end up having many actions in your controllers that return different fragments of HTML. I know, you think it’s normal, everyone does that.

- You loose a lot of control over the UI – you use DHTML techniques to deal with the UI and in the same time you need the server to get parts of that UI. This leads to a code duplication and in many cases ends up with a big mess.

- A user will have to wait until a request is done – that just sucks, that poor guy has to wait because you went back to the server for a little piece of HTML. How you are going to implement a responsive UI this way? “Your servers are fast”. Of course they are, but what if user’s ISP sucks? What if the user is downloading something and 99% of his bandwidth is gone?

Rendering HTML on the client-side is ridiculously simple. Consider the following example. Let’s say we have a page with a list of some people, the list is just a simple HTML table. It could look like this:

```generic
&lt;table&gt;
  &lt;thead&gt;
    &lt;tr&gt;
      &lt;th&gt;First Name&lt;/th&gt;
      &lt;th&gt;Last Name&lt;/th&gt;
      &lt;th&gt;E-Mail&lt;/th&gt;
    &lt;/tr&gt;
  &lt;/thead&gt;
  &lt;tbody id="people"&gt;
    &lt;!– here go people –&gt;
  &lt;tbody&gt;
  &lt;tfoot&gt;
    &lt;tr colspan="4"&gt;
      &lt;td&gt;
        &lt;a id="previous" href="#"&gt;Previous&lt;/a&gt;
        &lt;a id="next" href="#"&gt;Next&lt;/a&gt;
      &lt;/td&gt;
    &lt;/tr&gt;
  &lt;/tfoot&gt;
&lt;/table&gt;

```

As you can see the tbody element is empty, we will load its content after the entire page is loaded. Instead of a bunch of “tr” elements the server should return a nice JSON data which could look like this:

```generic
var people = [
 { id : 1, first_name : ‘John’, last_name : ‘Doe’, email : ‘john.doe@somewhere.com’ },
 { id : 2, first_name : ‘Jane’, last_name : ‘Doe’, email : ‘jane.doe@anywhere.com’ },
 { id : 3, first_name : ‘Third’, last_name : ‘Guy’, email : ‘third.guy@nowhere.com’ }
];

```

To render these data we obviously need a template. Prototype gives us a handy class called [Template](http://prototypejs.org/api/template) which is perfect for our needs. To create a template and render the list of people we need a few lines of JavaScript:

```generic
var personRowTemplate = new Template(
  ‘&lt;tr id="person_#{id}"&gt;&lt;td&gt;#{first_name}&lt;/td&gt;&lt;td&gt;#{last_name}&lt;/td&gt;&lt;td&gt;#{email}&lt;/td&gt;&lt;/tr&gt;’);

var peopleRows = ”;

people.each(function(person) {
  peopleRows += personRowTemplate.evaluate(person);
});

$(‘people’).update(peopleRows);

```

That’s pretty much it. It doesn’t look spectacular, huh? Now just think about the benefits of this approach:

- You have the data in JSON format, you can use them to render things like an edit form without going back to the server, thus user experience will be better

- You can be focused on building a nice JSON API for accessing data instead of implementing actions that return small pieces of HTML

- Your client-side code is cleaner and more consistent

Sounds like a good deal, doesn’t it? :)
