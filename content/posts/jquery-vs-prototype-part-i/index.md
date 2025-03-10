---
title: jQuery vs Prototype - part I
date: '2007-11-11'
categories:
- blog
tags:
- archives
- blog
- javascript
- jquery
- prototype
slug: jquery-vs-prototype-part-i
aliases:
- "/2007/11/11/jquery-vs-prototype-part-i"
- "/jquery-vs-prototype-part-i"
---

Prototype 1.6.0 was released to the public 4 days ago, at first I decided to check its performance and new features in comparison to the previous version, but being interested in other JavaScript libraries, I’ve changed my mind. Lets see how you can accomplish same tasks with the latest [Prototype](http://www.prototypejs.org) and [jQuery](http://jquery.com) libraries and simply see which one is faster. In this part I’m going to show the results of running single operations, in next part(s) I will prepare a sample website and write more complex test cases and, again, check how fast jQuery and Prototype can be (or how slow…).

### Test environment setup

The following software was used:

- Prototype 1.6.0
- jQuery 1.2.1
- Firefox 2.0.0.9
- Firebug 1.05
- Webdeveloper 1.1.4

Test page contains only one table with 500 rows, it’s generated using the following RHTML template:

```generic
<table>
<% (1..500).each do |i| %>
  <tr>
    <td class="first">
       i %>
    </td>
    <td class="second">
       "hello from #{i}" %>
    </td>
  </tr>
<% end %>
</table>

```

### Running the tests

Each operation was executed using Firebug’s console with Profiler turned on and repeated 3 times,
between each execution the page was reloaded. Cache in Firefox was disabled using Webdeveloper plugin.
Here are the results of 7 test operations showing average times and number of method calls in each operation:

1\. Adding ‘marked’ CSS class to every cell having ‘first’ CSS class:

| Library      | Operation                                                                       | Time (ms) | Method Calls |
| ------------ | ------------------------------------------------------------------------------- | --------- | ------------ |
| jQuery       | “\` erb $(‘td.first’).addClass(‘marked’) ”\`                                    | 102.495   | 3032         |
| Prototype #1 | “\` erb $$(‘td.first’).each(function(cell) { cell.addClassName(‘marked’) }) ”\` | 117.162   | 7056         |
| Prototype #2 | “\` erb $$(‘td.first’).invoke(‘addClassName’, ‘marked’) ”\`                     | 129.972   | 8062         |

_Comment_: no practical difference, although jQuery is a little faster.

2\. Removing CSS class from every table cell having “second” CSS class:

| Library      | Operation                                                                           | Time (ms) | Method Calls |
| ------------ | ----------------------------------------------------------------------------------- | --------- | ------------ |
| jQuery       | “\` erb $(‘td.second’).removeClass(‘second’) ”\`                                    | 109.855   | 3032         |
| Prototype #1 | “\` erb $$(‘td.second’).each(function(cell) { cell.removeClassName(‘second’) }) ”\` | 87.445    | 4551         |
| Prototype #2 | “\` erb $$(‘td.second’).invoke(‘removeClassName’, ‘second’) ”\`                     | 100.64    | 5557         |

_Comment_: No big difference, especially when comparing Prototype #2 option with jQuery.

3\. Setting ‘color’ CSS property in every div element which is inside a cell having ‘second’ CSS class:

| Library      | Operation                                                                            | Time (ms) | Method Calls |
| ------------ | ------------------------------------------------------------------------------------ | --------- | ------------ |
| jQuery       | “\` erb$(‘td.second div’).css(‘color’, ‘red’)”\`                                     | 173.906   | 3536         |
| Prototype #1 | “\` erb$$(‘td.second div’).each(function(el) { el.setStyle({ color : ‘red’ }) });”\` | 87.585    | 4563         |
| Prototype #2 | “\` erb$$(‘td.second div’).each(function(el) { el.setStyle(‘color : red’) });”\`     | 98.283    | 5064         |
| Prototype #3 | “\` erb$$(‘td.second div’).invoke(‘setStyle’, ‘color : red’);”\`                     | 107.81    | 6070         |

_Comment_: Same here, Prototype 2 x faster

4\. Adding new elements before every div element which is inside a cell having ‘second’ CSS class:

| Library | Operation                           | Time (ms) | Method Calls |
| ------- | ----------------------------------- | --------- | ------------ |
| jQuery  | “\` erb $(‘td.second div’).before(‘ |
### text

’) ”\` | 368.611 | 15066 |
| Prototype #1 | “\` erb$$(‘td.second div’).each(function(el) { el.insert({ before: ‘<h3>text</h3>’ }) });”\` | 1252.016 | 17088 |
| Prototype #2 | “\` erb$$(‘td.second div’).invoke(‘insert’, { before: ‘<h3>text</h3>’ });”\` | 1316.969 | 19096 |

_Comment_: Wow…jQuery is almost 4 times faster, I should point out that [Element#insert](http://www.prototypejs.org/api/element/insert) is a new method introduced in Prototype 1.6.0.

5\. Removing all div elements which are inside cells having ‘second’ CSS class:

| Library      | Operation                                                         | Time (ms) | Method Calls |
| ------------ | ----------------------------------------------------------------- | --------- | ------------ |
| jQuery       | “\` erb$(‘td.second div’).remove()”\`                             | 151.955   | 2032         |
| Prototype #1 | “\` erb$$(‘td.second div’).each(Element.remove);”\`               | 65.785    | 3060         |
| Prototype #2 | “\` erb$$(‘td.second div’).invoke(‘remove’);”\`                   | 94,105    | 5068         |
| Prototype #3 | “\` erb$$(‘td.second div’).each(function(el) { el.remove() });”\` | 83.591    | 4062         |

_Comment_: Prototype more then 2 times faster.

6\. Hiding and un-hiding all div elements which are inside cells having ‘second’ CSS class:

| Library      | Operation                                                                                                                 | Time (ms) | Method Calls |
| ------------ | ------------------------------------------------------------------------------------------------------------------------- | --------- | ------------ |
| jQuery       | “\` erb$(‘td.second div’).toggle();$(‘td.second div’).toggle();”\`                                                        | 1948.825  | 47653        |
| Prototype #1 | “\` erb$$(‘td.second div’).each(Element.toggle);$$(‘td.second div’).each(Element.toggle);”\`                              | 158.987   | 14106        |
| Prototype #2 | “\` erb$$(‘td.second div’).each(function(el) { el.toggle() }); $$(‘td.second div’).each(function(el) { el.toggle() });”\` | 191.096   | 16110        |

_Comment_: jQuery tragedy, Prototype toggles visibility of 500 divs 10 times faster!

7\. Attaching event listeners to all div elements which are inside cells having ‘second’ CSS class:

| Library      | Operation                                                                                                      | Time (ms) | Method Calls |
| ------------ | -------------------------------------------------------------------------------------------------------------- | --------- | ------------ |
| jQuery       | “\` erb$(‘td.second div’).bind(‘click’, function(){ alert(this.innerHTML) })”\`                                | 146.19    | 3535         |
| Prototype #1 | “\` erb$$(‘td.second div’).invoke(‘observe’, ‘click’, function(){ alert(this.innerHTML) });”\`                 | 169,889   | 11581        |
| Prototype #2 | “\` erb$$(‘td.second div’).each(function(el) { el.observe(‘click’, function(){ alert(this.innerHTML) }) });”\` | 164.456   | 10575        |

_Comment_: no practical difference.

### General conclusion and impression

Executed tests show that Prototype seems to be faster then jQuery, with the exception of the new insertion method, which performance should be improved. Although I like jQuery syntax more then Prototype, the performance is way more important then saving few lines of code. Of course tests that I made don’t show how these libraries act in a real application, which is my task for the next part(s) of this article. Despite the results I must admit that I’m very excited about jQuery, my general impression is that this library is more mature then Prototype.

You may want to check out [part II](/2008/2/3/jquery-vs-prototype-part---ii)
