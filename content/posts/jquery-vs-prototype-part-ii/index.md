---
title: jQuery vs Prototype - part II
date: '2008-02-03'
categories:
- blog
tags:
- archives
- blog
- javascript
- jquery
- prototype
slug: jquery-vs-prototype-part-ii
aliases:
- "/2008/02/03/jquery-vs-prototype-part-ii"
- "/jquery-vs-prototype-part-ii"
---

Recently, new versions of jQuery and Prototype have been released – it’s a perfect moment for a part number 2. On the official Prototype blog we [can read](http://www.prototypejs.org/2008/1/25/prototype-1-6-0-2-bug-fixes-performance-improvements-and-security) that the general performance of CSS selectors is now improved, unfortunately only for Safari 3, but Element#up/#down/#next/#previous should now be faster on all browsers, it’s a good news as they were really slow. On the other hand we have jQuery [official announcement](http://jquery.com/blog/2008/01/15/jquery-122-2nd-birthday-present) with information that jQuery is now 300% faster – we’ll see!

This time I made a step forward and decided to use a custom JavaScript-based testing environment instead of running tests using Firebug profiler. The obvious advantage is that I was able to run all the tests on 4 different browsers. New test cases aren’t much different then in the first part, let’s say it’s a modification of the previous ones with some extra operations and a little more complex HTML structure.

### Test environment setup

Libraries:

- jQuery 1.2.2
- Prototype 1.6.0.2

All the tests were run on the following browsers:

- Firefox 2.0.0.11
- Konqueror 4.00.00
- Opera 9.50\_beta1
- Internet Explorer 7 (**but using Windows on VirtualBox!**)

A tiny piece of JavaScript code is responsible for running the tests, each operation is called only once inside a try-catch block, so the essential part looks like this:

```generic
    try {
      var start = new Date;
      test();
      var end = new Date - start;
      this.writeResults(test, end);
    } catch(e) {
      test.resultCell.innerHTML = 'Exception caught: '+e.message+'';
    }

```

There is a 3 seconds break between each test run, results are automatically inserted into the results table. If you want, you can check it out on your own, just go [right here](http://solnic.codes/test_runner/index.html) and hit the ‘run tests!’ button.

### The results

I’m happy to see that all tests pass on the latest Konqueror, previous version from KDE3 fails on some Prototype tests. I don’t own Mac, so you won’t see Safari results here, although I’ve run the tests on my friend’s MacBook with very similar hardware as my laptop has (Intel Core Duo 2ghz + 2 gigs of RAM), and it was faster even then Konqueror (no, it doesn’t mean his MacBook is faster then my laptop!!!! ;)).

I’ve run everything 3 times, here are average results in ms:

<table id="test_results" class="test_results"><colgroup><col style="width:12px;"> <col style="width:55px;"> <col style="width:220px;"> <col style="width:24px;"> <col style="width:24px;"> <col style="width:24px;"> <col style="width:24px;"></colgroup><tbody><tr><th>#</th><th>Library</th><th>Test</th><th>Firefox</th><th>Konqueror</th><th>IE7</th><th>Opera</th></tr><tr><td rowspan="2"><b>1</b></td><td style="color:red;">jQuery</td><td><div></div>“` erb $(‘td.counter’).addClass(‘marked’) ”`<div></div></td><td>96.6</td><td>32.3</td><td class="jq_faster">70</td><td class="jq_faster">37</td></tr><tr><td style="color:blue;">Prototype</td><td><div></div>“` erb $$(‘td.counter’).each(function(el){el.addClassName(‘marked’)}) ”`</td><td>108.3</td><td>49.6</td><td>858</td><td>75.7</td></tr><tr><td rowspan="2"><b>2</b></td><td style="color:red;">jQuery</td><td>“` erb$(‘td.counter span.special’).removeClass(‘special’)”`</td><td>62</td><td>23.6</td><td class="jq_faster">46.6</td><td>25.6</td></tr><tr><td style="color:blue;">Prototype</td><td>“` erb $$(‘td.counter span.special’).each(function(el) {el.removeClassName(‘special’)}) ”`</td><td class="proto_faster">28</td><td>23.7</td><td>167</td><td>24.7</td></tr><tr><td rowspan="2"><b>3</b></td><td style="color:red;">jQuery</td><td>“` erb$(‘td.content span.odd’).css(‘color’, ‘red’)”`</td><td>124.7</td><td>40.3</td><td class="jq_faster">63.7</td><td>38.3</td></tr><tr><td style="color:blue;">Prototype</td><td>“` erb$$(‘td.content span.odd’).each(function(el) {<br>el.setStyle(‘color: red’)<br>})”`</td><td class="proto_faster">55.7</td><td>31</td><td>297</td><td>33.7</td></tr><tr><td rowspan="2"><b>4</b></td><td style="color:red;">jQuery</td><td>“` erb $(‘td.content span.even’).before(‘<h3 style="display:none;">text</h3>’) ”`</td><td>382.7</td><td>177.3</td><td>373.7</td><td>205.3</td></tr><tr><td style="color:blue;">Prototype</td><td>“` erb $$(‘td.content span.even’).each(function(el) { el.insert({before:‘<h3 style="display:none;">text</h3>’}) }) ”`</td><td>359</td><td class="proto_faster">90.7</td><td>527</td><td class="proto_faster">138.7</td></tr><tr><td rowspan="2"><b>5</b></td><td style="color:red;">jQuery</td><td>“` erb$(‘td.content h3’).show()”`</td><td>178.7</td><td>227.7</td><td class="jq_faster">83.3</td><td>1161.7</td></tr><tr><td style="color:blue;">Prototype</td><td>“` erb$$(‘td.content h3’).each(Element.show)”`</td><td class="proto_faster">38</td><td class="proto_faster">21</td><td>250.7</td><td class="proto_faster">19</td></tr><tr><td rowspan="2"><b>6</b></td><td style="color:red;">jQuery</td><td>“` erb$(‘div.special’).hide()”`</td><td>90</td><td>81.3</td><td class="jq_faster">33.7</td><td>375.3</td></tr><tr><td style="color:blue;">Prototype</td><td>“` erb$$(‘div.special’).each(Element.hide)”`</td><td>18</td><td>7</td><td>73.3</td><td>12</td></tr><tr><td rowspan="2"><b>7</b></td><td style="color:red;">jQuery</td><td>“` erb$(‘div.special, td.content .odd’).toggle()”`</td><td>637.7</td><td>431.7</td><td>517</td><td>1360.3</td></tr><tr><td style="color:blue;">Prototype</td><td>“` erb$$(‘div.special, td.content .odd’).each(Element.toggle)”`</td><td class="proto_faster">71</td><td class="proto_faster">43.7</td><td class="proto_faster">106.7</td><td class="proto_faster">43</td></tr><tr><td rowspan="2"><b>8</b></td><td style="color:red;">jQuery</td><td>“` erb$(‘span.odd’).remove()”`</td><td>132.7</td><td>59.3</td><td>123.3</td><td>66.7</td></tr><tr><td style="color:blue;">Prototype</td><td>“` erb$$(‘span.odd’).each(Element.remove)”`</td><td class="proto_faster">29</td><td class="proto_faster">11.7</td><td class="proto_faster">36.7</td><td class="proto_faster">19.3</td></tr><tr><td rowspan="2"><b>9</b></td><td style="color:red;">jQuery</td><td>“` erb$(‘#data p.lost:first’).html(‘gotcha!’)”`</td><td class="jq_faster">5</td><td>1.7</td><td>10</td><td class="jq_faster">3.3</td></tr><tr><td style="color:blue;">Prototype</td><td>“` erb$(‘data’).down(‘p.lost’).update(‘gotcha!’)”`</td><td>11.7</td><td>2</td><td>10</td><td>7.3</td></tr></tbody></table>

### Conclusion #2

Prototype was at least 2 times faster then jQuery in 15 cases, and jQuery was faster then Prototype in 8 cases. What library should I choose? In my case I will stick with Prototype, because it offers the same functionality as jQuery does + more and it’s faster. jQuery is probably better for projects where there’s a need for some fancy UI effects and that’s it, but it’s just an assumption, correct me if I’m wrong…
