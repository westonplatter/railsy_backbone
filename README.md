# RailsyBackbone
Backbone 1.0.0  
Underscore 1.5.1

[![Build Status](https://travis-ci.org/westonplatter/railsy_backbone.png?branch=master)](https://travis-ci.org/westonplatter/railsy_backbone)

Questions/Suggestions &nbsp; => &nbsp; [open a GitHub issue - 24 hr response time](https://github.com/westonplatter/railsy_backbone/issues/new)

## Rails Setup

### Install

Add this line to Gemfile,

    gem 'railsy_backbone'

And then,

    $ bundle install
    $ rails g backbone:install
    
This requires `underscore`, `backbone`, and JS customizations to make Backbone play nice with Rails (see Javscript files with `rails_backbone.` prefix regarding what changed).

    //= require jquery
    //= require jquery_ujs
    //= require underscore
    //= require backbone
    //= require railsy_backbone.sync
    //= require railsy_backbone.datalink
    //= require backbone/<your_application_name_here>
    //= require_tree .

### Generators
Rails Install  
Backbone Model  
Backbone Router  
Backbone Scaffold  

### Example Usage      

Create new rails app, 

    rails new library
    cd library

Install `railsy_backbone`,
    
    # add railsy_backbone to Gemfile
    bundle install
    rails g backbone:install

Generate a standard Rails scaffold,
    
    rails g scaffold Book title:string author:string
    rake db:migrate

Generate a `Backbone` scaffold, 
    
    rails g backbone:scaffold Book title:string author:string
    
Edit `books/index.html` to execute actions through the Backbone scaffold UI rather than routing to different pages. 
    
    ### ERB
    
    <div id="books"></div>

    <script type="text/javascript">
      $(function() {
        window.router = new Library.Routers.BooksRouter({books: <%= @books.to_json.html_safe -%>});
        Backbone.history.start();
      });
    </script>
    
    
    ### HAML
    
    #books
    
    :javascript
      $(function() {
        window.router = new Library.Routers.BooksRouter({books: #{@books.to_json.html_safe}});
        Backbone.history.start();
      });


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


## Docs

[Here's the link to our docs](http://westonplatter.github.io/railsy_backbone/).

__I really value clear communication__ (I'm serious!). If you think something is missing in the docs, __please__ let me know via a GitHub issue ([create issues here](https://github.com/westonplatter/railsy_backbone/issues)), and I'll look at adding it. 



## Credits
See LICENSE
