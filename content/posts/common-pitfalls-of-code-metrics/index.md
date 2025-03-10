---
title: Common Pitfalls Of Code Metrics
date: '2014-01-22'
categories:
- blog
tags:
- archives
- blog
- programming
- refactoring
- tdd
slug: common-pitfalls-of-code-metrics
aliases:
- "/2014/01/22/common-pitfalls-of-code-metrics"
- "/common-pitfalls-of-code-metrics"
---

Code metrics and code metric tools can be both helpful and harmful. The difference between the two is learning to interpret the results and use the feedback to improve yourself and your code.

I have a lot of experience with code metric tools. Over the last couple of years I’ve used them on a daily basis. Tools measuring simple things like test coverage, lines of code \[LoC\] per class/method, naming, and column length along with more advanced measurements for code complexity, churn, and mutation coverage. This experience has taught me a lot about code quality and object-oriented design. I believe that the lessons learned and the time spend refactoring my code have made me a better programmer. As is usually the case, nothing’s perfect and I have noticed that I encounter very specific pitfalls along the way. Here’s some of them and how I deal with them. I hope that my experience can help you when you face the same problems.

## I’ve Got It Covered

Test coverage is probably the most popular code metric. To 100% or not to 100%, that is the question. The pitfall? Chasing 100% test coverage as a goal rather than having that coverage be a result of good testing practices. Tests should help in future refactorings. For example, an abstract class with methods that raise NotImplementedError will need tests for those methods to achieve full coverage. Sure the class is fully tested but as the class needs to grow and change the increased maintenance cost for those tests may outweigh their value. When building a bigger system like a web-application there are many more cases where the cost must be considered.

I use code coverage numbers all the time just not for the sake of 100%. I don’t add tests just to cover a missed line. If I missed a line because of sloppy testing practices then I have a bigger problem than test coverage and the numbers can help me find these issues. In some cases, I may leave off the tests for low-risk functionality where it would be easier to fix a mistake later instead of maintain lots of brittle tests. The real solution for me is Test Driven Development \[TDD\]. Using TDD, and specifically tests before implementation (or test first), gives me the confidence that things work as expected with as little code as possible. When coverage and TDD are used together I have a powerful feedback loop that tells me more than 100% coverage ever could.

## It’s Just a Number

Lines of code, or LoC, show up often in code metrics. The simple interpretation of LoC is the larger the number of lines, the worse the code and it’s easy to get trapped by that logic. A large LoC number is just an indicator. It’s just a number. A method with 20 lines might be doing too much and a class with 220 lines is probably responsible for too many things but you can’t be sure just by looking at this number. You can have a class with trivial functionality that is implemented in 120 lines and one with 60 lines that is crazy complex, especially in a language like Ruby.

The common response to LoC growing is to break classes and methods in to smaller pieces. Unfortunately, this new code is often _harder_ to understand. If a simple method or a class is broken down into smaller pieces it can be more difficult to follow the logic. Now you need to jump between multiple classes or methods while maintaining the entire context in your mind. That’s harder than having more LoC in a single place where you _just see it all_ and can figure things out quickly.

I focus on _what_ is going on in my code rather than the number of lines. I use the LoC as a message that something might be larger than I’d like. I keep a keen eye on long classes and methods but generally avoid the temptation to break things down prematurely. I decide if the code is easy to understand. The tool cannot do that for me.

## Something Smells

Advanced metric tools can perform analysis to find a wide variety of code smells. A natural reaction to a problem in code is to immediately work on the fix. By their definition, code smells are only potential problems. Smell smoke? There _might_ be a fire. Just like prematurely breaking things apart to help with LoC can cause problems the removal of these smells too early isn’t necessarily the right thing to do.

It is my job to be aware of specific problem areas in my code and use my judgement to decide if a fix is needed now, later, or if a fix is needed at all. The code I write needs to evolve in a natural way that is based on my understanding of the problem I’m solving. I may be at a stage in a project where dealing with that code smell isn’t worth the effort. Code smell tools make the issue of when to fix a problem and when to ignore it even more subtle. These tools allow for configuration to skip certain things during their analysis. There have been times where I had lots of configured exceptions and the maintenance of the configuration files became, not only a distraction, but a very time consuming part of a project. Now I only remove an identified code smell if it is already causing me trouble.

## Who’s Afraid Of The Big Bad Code (Metrics)?

Code metrics can be fun: “_Look! Jane refactored User model and its grade is now an A! WOW Jane that’s so awesome! Thanks Jane!_” Jane obviously made things better but that’s not the whole story, is it? A week later, here comes John who needs to add a feature to the User model: “_OMG Jane just bumped the score of this model last week and it’s gonna go down with my implementation. What do I do?!_”. Yes, John now fears to push the code he wrote.

When code metrics are used there is a very real risk that people will be afraid to write code. You may be thinking, “It’s good that John stops for a minute. He can think twice and refactor to make the code better.” That’s an ideal situation. It’s not reality. We may miss that his implementation is tested, working, and it’s perfectly acceptable that the grade goes down.

I’ve seen environments where a strict adhearance to code metrics has led to stress for the developers on the team. A stressed environment is a broken environment. Use the metrics as _one_ of the tools not the _only_ tools for improving the code and improving the people that write it. Keep this in mind when implementing code metrics for your team.

## There’s A Theme Here

The tools alone don’t help without a person to interpret the warnings and analysis they provide. In every case, I take the information from the tools and decide how to use this new feedback to make things better.

Using code metric tools to measure every aspect of the code you write means you may start working towards making the tools happy rather then achieving the ultimate goal of software that helps people. Some like to talk about programming as an art and as a craft – we create things and we can create them in a beatiful way. What I’ve noticed while using code metric tools the Hard Way™ is that it can take away the humanity of writing code. Creation becomes mechanical with nothing but mechanical feedback. All numbers and no intuition. Machines do what they’re told exactly the way they were told to do it. People, on the other hand, are chaotic. They do things in various ways – making mistakes, (hopefully) learning, and moving on. The learning process is what people are really good at. We’re trying hard to make machines learn (Because Terminator 2 is such a lovely vision, right?). They’re not learning yet so it is left to us to gain insight and grow.

We’re humans, we make mistakes, we can’t avoid that. That’s the beauty of who we are. Tools can help you but if you take it too far you will start working like a machine. The tools will be happy. Rules followed. Code conforms to your high standards. Suddenly, making the simplest change is a huge effort because you’re trapped by the numbers. Misery ensues.

A list of the lessons I’ve learned may help:

- code metrics are great
- use code metrics on your projects
- learn how to interpret the results from these tools
- don’t take them too far
- don’t let them stop you from writing code
- we’re humans, we make mistakes, we learn
- TDD > code metrics (TDD + code metrics is even better!)

What do you use code metrics for? Have you seen other pitfalls in your experience? Totally disagree? Let’s talk about it.

* * *

Thanks to [Don Morrison](https://twitter.com/elskwid) for helping me with putting this article together!
