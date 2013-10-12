# railsy_backbone

[![Gem Version](https://badge.fury.io/rb/railsy_backbone.png)](http://badge.fury.io/rb/railsy_backbone) [![Build Status](https://travis-ci.org/westonplatter/railsy_backbone.png?branch=master)](https://travis-ci.org/westonplatter/railsy_backbone)

A clone of [codebrew/backbone-rails](https://github.com/codebrew/backbone-rails) with updated Backbone, Underscore, and jquery-rails versions.

Provides Backbone & Underscore files and modifies Backbone to:  
- include the Rails authenticity token in HTTP requests  
- nest model attributes within the declared &nbsp; `paramRoot` &nbsp;, EG, 

```js
var Book = Backbone.Model.extend({ 
  url: '/books',
  paramRoot: 'book'
});

var book_instance = new Book({ 
  title:  'the illiad', 
  author: 'homer'
});

book_instance.sync();
```

This will cause the resulting HTTP POST to be,

```sh
Started POST "/books" for 127.0.0.1 ...
  Processing by BooksController#create as JSON
  Parameters: { "book" => {  "title" => "the illiad",  "author" => "homer", "id" => 1 } }
```

## Branches

master:  
- Backbone 1.1.0  
- Underscore 1.5.2  

1-0-stable  
- Backbone 1.0.0  
- Underscore 1.5.1  

## Rails Setup

### Install

Add this line to Gemfile,

    gem 'railsy_backbone'

And then,

    $ bundle install
    $ rails g backbone:install
    
This requires Backbone, Underscore, and the Backbone modifications to implement
the Rails authenticity token and nesting model attributes in the paramsRoot 
(see Javscript files with the `railsy_backbone.` prefix for details).

These will be added to your `app/assets/javascripts/application.js`:

    //= require jquery
    //= require jquery_ujs
    //= require underscore
    //= require backbone
    //= require railsy_backbone.sync
    //= require railsy_backbone.datalink
    //= require backbone/<your_rails_application_name>
    //= require_tree .

### Generators  
Backbone Model `$ rails g backbone:model`  
Backbone Router `$ rails g backbone:router`  
Backbone Scaffold `$ rails g backbone:scaffold`  

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
    
If you're using ERB, `index.html.erb`
    
    <div id="books"></div>

    <script type="text/javascript">
      $(function() {
        window.router = new Library.Routers.BooksRouter({books: <%= @books.to_json.html_safe -%>});
        Backbone.history.start();
      });
    </script>
    
Or HAML, `index.html.haml`
    
    #books
    
    :javascript
      $(function() {
        window.router = new Library.Routers.BooksRouter({books: #{@books.to_json.html_safe}});
        Backbone.history.start();
      });

If you're using the default Rails 4 scaffold generators, you'll need to adjust 
the default JSON show view (IE, `show.json`) to render the `id` attribute.

    # BROKEN -- default rails generated show.json.jbuilder
    json.extract! @book, :title, :author, :created_at, :updated_at

    # FIXED --- after adding `id`
    json.extract! @book, :id, :title, :author, :created_at, :updated_at

Without adjusting the JSON show view, you will be redirected to a "undefined" 
url after creating an object.


## Docs
[Link to the docs](http://westonplatter.github.io/railsy_backbone/).

I value clear communication __(I'm serious!)__. If you think something is missing in the docs, __please__ open a GitHub issue ([create issues here](https://github.com/westonplatter/railsy_backbone/issues)), and I'd love to add it if it makes sense.

## Contributors
[These awesome people](https://github.com/westonplatter/railsy_backbone/graphs/contributors) infused their awesome talent in this project.

## Credits
Inspired by and copied from Ryan Fitzgerald's [codebrew/backbone-rails](https://github.com/codebrew/backbone-rails).

## License
See LICENSE
