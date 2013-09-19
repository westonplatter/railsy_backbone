# RailsyBackbone
Backbone 1.0.0  
Underscore 1.5.1

[![Build Status](https://travis-ci.org/westonplatter/railsy_backbone.png?branch=master)](https://travis-ci.org/westonplatter/railsy_backbone)

## Features

1. [Nested Model Attributes](#nested-model-attributes)
2. [Automatic Rails CSRF Integration](#automatic-rails-csrf-integration)

### Nested Model Attributes
Allows you to specify a namespace for model attributes by defining a  ```paramRoot```  attribute. For example, 

    var Book = Backbone.Model.extend({ 
      url: '/books',
      paramRoot: 'book'
    });

    var book_instance = new Book({ 
      title:  'the illiad', 
      author: 'homer'
    });

    book_instance.sync();

This will cause the HTTP POST to look like this, 

    Started POST "/books" for 127.0.0.1 at 2013-08-03 18:08:56 -0600
      Processing by BooksController#create as JSON
      Parameters: { "book" => { "title" => "the illiad", "author" => "homer" }}


### Automatic Rails CSRF Integration
Automatically handles the Rails `authenticity_token`. Or, more technically, sets the  `xhr.setRequestHeader`  to the Rails CSRF token supplied in the HTML `header` meta tag.

<br>

## Installation

Add this line to your application's Gemfile:

    gem 'railsy_backbone', '~> 0.0.3'

And then execute:

    $ bundle

## Docs

[Here's the link to our docs](http://westonplatter.github.io/railsy_backbone/).

__We really value clear communication__ (we're serious!). If you think something is missing in the docs, __please__ let us know via a GitHub issue ([create issues here](https://github.com/westonplatter/railsy_backbone/issues)), and we'll look at adding it. 

## Rails setup
This gem requires the use of rails 3.1 and greater, coffeescript and the new rails asset pipeline provided by sprockets.

This gem vendors the latest version of underscore.js and backbone.js for Rails 3.1 and greater. The files will be added to the asset pipeline and available for you to use. 
    
### Installation

In your Gemfile, add this line:

    gem "rails-backbone"
  
Then run the following commands:

    bundle install
    rails g backbone:install

### Layout and namespacing

Running `rails g backbone:install` will create the following directory structure under `app/assets/javascripts/backbone`:
  
    routers/
    models/
    templates/
    views/
    
It will also create a toplevel app_name.coffee file to setup namespacing and setup initial requires.
    
## Generators
backbone-rails provides 3 simple generators to help get you started using backbone.js with rails 3.1 and greater. 
The generators will only create client side code (javascript).

### Model Generator

    rails g backbone:model
    
This generator creates a backbone model and collection inside `app/assets/javascript/backbone/models` to be used to talk to the rails backend.

### Routers
    
    rails g backbone:router
    
This generator creates a backbone router with corresponding views and templates for the given actions provided.

### Scaffolding

    rails g backbone:scaffold
    
This generator creates a router, views, templates, model and collection to create a simple crud single page app

## Example Usage

Created a new rails application called `blog`.

    rails new blog

Edit your Gemfile and add

    gem 'rails-backbone'

Install the gem and generate scaffolding.

    bundle install
    rails g backbone:install
    rails g scaffold Post title:string content:string
    rake db:migrate
    rails g backbone:scaffold Post title:string content:string
    
You now have installed the backbone-rails gem, setup a default directory structure for your frontend backbone code. 
Then you generated the usual rails server side crud scaffolding and finally generated backbone.js code to provide a simple single page crud app.
You have one last step:

Edit your posts index view `app/views/posts/index.html.erb` with the following contents:

    <div id="posts"></div>

    <script type="text/javascript">
      $(function() {
        // Blog is the app name
        window.router = new Blog.Routers.PostsRouter({posts: <%= @posts.to_json.html_safe -%>});
        Backbone.history.start();
      });
    </script>
    
If you prefer haml, this is equivalent to inserting the following code into `app/views/posts/index.html.haml`:

    :javascript
      $(function() {
        // Blog is the app name
        window.router = new Blog.Routers.PostsRouter({posts: #{@posts.to_json.html_safe}});
        Backbone.history.start();
      });

    
Now start your server `rails s` and browse to [localhost:3000/posts](http://localhost:3000/posts)
You should now have a fully functioning single page crud app for Post models.

## Credits
See LICENSE
