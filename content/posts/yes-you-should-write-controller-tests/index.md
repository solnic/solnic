---
title: Yes, You Should Write Controller Tests!
date: '2012-02-02'
categories:
- blog
tags:
- archives
- blog
- rails
- rspec
- ruby
- tdd
slug: yes-you-should-write-controller-tests
aliases:
- "/2012/02/02/yes-you-should-write-controller-tests"
- "/yes-you-should-write-controller-tests"
---

It really surprises me that there are people arguing that writing controller tests doesn’t make sense. Probably the most common argument is that actions are covered in acceptence tests along with checking if views are properly rendered. Right? Right…well that’s just wrong! Are you trying to say that your slow acceptance tests are covering every possible controller action scenario? Are you trying to say that, for instance, every redirect that should take place is tested within an _acceptance test_? Are you also checking every invalid request in acceptance tests? Are you telling me that your acceptance test suite takes 27 hours and 13 minutes to finish because you fully test your controllers there?! Oh I’m sure that your acceptance test suite runs faster and you probably cover only ‘the happy scenarios’ there…which basically means you miss A LOT of test coverage.

## A Simple Fact About a Controller

Here’s a simple fact about a controller - _it’s a class with methods_! Yes, it’s a class with methods I repeat. It should have tests. Every method (action) should be covered by a test.

Why? Well, for the same reason that you write tests for any other class in your application. We want to make sure that our code behaves like expected. It’s also much easier to keep your controllers thin when you have tests. If it’s trivial to write a test for a controller then it’s probably a well implemented controller. If you’re drowning in mocks then you probably want to refactor your controller.

Here’s an example of a users controller with a sample create action:

```generic
class UsersController < ApplicationController
  before_filter :load_group

  rescue_from ActiveRecord::RecordNotFound do
    render :not_found
  end

  def create
    @user = @group.users.create(params[:user])

    if @user.persisted?
      redirect users_path, :notice => ‘User created!’
    else
      render :new
    end
  end

  private

  def load_group
    @group = Group.find(params[:group_id])
  end
end

```

As you can see we load a group object in the before filter and then we use that object to create a new user. Pretty dead-simple. If you just write an acceptance spec for this controller I bet you will not cover the case when the group cannot be found. After all people usually write acceptance tests for optimistic scenarios. If they want to cover every case then I’m sure they will miss the deadline ;)

But it’s not just about covering every path! It’s also about the quality of the code. When you look at the example above you probably won’t see any code smells, right? OK so let me write a spec for the create action:

```generic
describe UsersController do
  describe "#create" do
    subject { post :create, :group_id => group_id, :user => attributes }

    let(:group_id) { mock(‘group_id’) }
    let(:group)    { mock(‘group’) }
    let(:user)     { mock(‘user’) }
    let(:users)    { mock(‘users’) }

    before do
      Group.should_receive(:find).with(group_id).and_return(group)
      group.should_receive(:users).and_return(users)
      users.should_receive(:create).with(attributes).and_return(user)
    end

    context ‘when attributes are valid’ do
      it ‘saves the user and redirects to the index page’ do
        user.should_receive(:persisted?).and_return(true)
        subject.should redirect_to(:users)
      end
    end

    context ‘when attributes are not valid’ do
      it ‘saves the user and redirects to the index page’ do
        user.should_receive(:persisted?).and_return(false)
        subject.should render_template(:new)
      end
    end
  end
end

```

What happens there? Because we reach deeper into group object, get its users and then use it to build a new user the spec requires more mocks then it should. This is a trivial example but you can probably imagine how a spec would look like if the action was more complicated, had more branching logic and even more _structural coupling_.

Let’s quickly make a small refactor of the action:

```generic
class UsersController < ApplicationController
  # stuff

  def create
    @user = @group.create_user(params[:user])

    if @user.persisted?
      redirect users_path, :notice => ‘User created!’
    else
      render :new
    end
  end

  # more stuff
end

```

Now the spec will be a bit simpler:

```generic
describe UsersController do
  describe "#create" do
    subject { post :create, :group_id => group_id, :user => attributes }

    let(:group_id) { mock(‘group_id’) }
    let(:group)    { mock(‘group’) }
    let(:user)     { mock(‘user’) }

    before do
      Group.should_receive(:find).with(group_id).and_return(group)
      group.should_receive(:create_user).with(attributes).and_return(users)
    end

    context ‘when attributes are valid’ do
      it ‘saves the user and redirects to the index page’ do
        user.should_receive(:persisted?).and_return(true)
        subject.should redirect_to(:users)
      end
    end

    context ‘when attributes are not valid’ do
      it ‘saves the user and redirects to the index page’ do
        user.should_receive(:persisted?).and_return(false)
        subject.should render_template(:new)
      end
    end
  end
end

```

We should also add an example checking the case where a group is not found. This is going to be a rather rare case but this doesn’t change the fact that we should have a test for it:

```generic
describe UsersController do
  subject { post :create, :group_id => group_id, :user => attributes }

  let(:group_id) { mock(‘group_id’) }
  let(:group)    { mock(‘group’) }

  describe ‘#create’ do
    context ‘when group is not found’ do
      before do
        Group.should_receive(:find).with(group_id).
          and_raise(ActiveRecord::RecordNotFound)
      end

      it { should render_template(:not_found) }
    end
  end
end

```

That’s it! Small test, fast test. Code is covered. Controller is thin. Now it’s probably a good idea to write some views specs for users controller too but I’m not going to write about it here, that’s boring ;)

## Summing up

Yes, you should write tests for controllers. Whenever somebody asks you if he/she should write them, your answer should be ‘yes!’. There are no good arguments against writing controller tests. It’s code after all, it should be covered by tests. Let the tests drive your design and you will be happy with your controllers, otherwise you might end up with a mess. Without proper tests you won’t be able to truly verify if your controllers are thin and well designed. So please go and write controller tests!

In case you missed it you might want to read Avdi’s great post about [“Law of Demeter”](http://avdi.org/devblog/2011/07/05/demeter-its-not-just-a-good-idea-its-the-law/) where he writes about structural coupling which is mentioned in this post too.
