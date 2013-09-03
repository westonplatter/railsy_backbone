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

    gem 'railsy_backbone', github: 'westonplatter/railsy_backbone'

And then execute:

    $ bundle

## Docs

[Here's the link to our docs](http://westonplatter.github.io/railsy_backbone/).

__We really value clear communication__ (we're serious!). If you think something is missing in the docs, __please__ let us know via a GitHub issue ([create issues here](https://github.com/westonplatter/railsy_backbone/issues)), and we'll look at adding it. 


## Credits
See LICENSE
