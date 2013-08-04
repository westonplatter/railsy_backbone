# RailsyBackbone
Backbone 1.0.0  
Underscore 1.5.1

## Features

### Nested Model Attributes
Allows you to specify a namespace for model attributes by defining a  ```paramRoot```  attribute. For example, 

```javascript
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

This will cause the HTTP POST to look like this, 

```sh
Started POST "/books" for 127.0.0.1 at 2013-08-03 18:08:56 -0600
  Processing by BooksController#create as JSON
  Parameters: { "book" => { "title" => "the illiad", "author" => "homer" }}
```

### Works with Rails CSRF
Sets the  ```xhr.setRequestHeader```  to the Rails CSRF token in the header.

<br>

## Installation

Add this line to your application's Gemfile:

    gem 'railsy_backbone', github: 'westonplatter/railsy_backbone'

And then execute:

    $ bundle

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
