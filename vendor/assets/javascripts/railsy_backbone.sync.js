( function($){
  
  // Backbone.sync
  // -------------

  // Need to define the methodMap since it's called from within Backbone.sync
  //
  var methodMap = {
      'create': 'POST',
      'update': 'PUT',
      'patch':  'PATCH',
      'delete': 'DELETE',
      'read':   'GET'
    };

  var urlError = function() {
    throw new Error("A 'url' property or function must be specified");
  };

  // Overriding Backbone.sync to nest model attributes in within the paramRoot
  // key-value JSON hashmap.
  // 
  // For example, when saving a new Model, 
  //
  //   var Book = Backbone.Model.extend({ 
  //     url: '/books',
  //     paramRoot: 'book'
  //   });
  // 
  //   var book_instance = new Book({ 
  //     title:  'the illiad', 
  //     author: 'homer'
  //   });
  //
  //   book_instance.sync();
  //
  // This will cause the HTTP POST to look like this, 
  //
  // Started POST "/books" for 127.0.0.1 at 2013-08-03 18:08:56 -0600
  //   Processing by BooksController#create as JSON
  //   Parameters: { "book" => { "title" => "the illiad", "author" => "home" }}
  // 
  //
  // Everything that is not explicitly called out as **railys_backbone** code, is
  // unmodified Backbone code.
  // 
  Backbone.sync = function(method, model, options) {
    var type = methodMap[method];

    // Default options, unless specified.
    _.defaults(options || (options = {}), {
      emulateHTTP: Backbone.emulateHTTP,
      emulateJSON: Backbone.emulateJSON
    });

    // Default JSON-request options.
    var params = {type: type, dataType: 'json'};

    // Ensure that we have a URL.
    if (!options.url) {
      params.url = _.result(model, 'url') || urlError();
    }
    
    // =========================================================================
    // railsy_backbone
    // -------------------------------------------------------------------------
    // include the Rails CSRF token on HTTP PUTs/POSTs    
    // 
    if(!options.noCSRF){
      var beforeSend = options.beforeSend;
      
      // Set X-CSRF-Token HTTP header
      options.beforeSend = function(xhr) {
        var token = $('meta[name="csrf-token"]').attr('content');
        if (token) xhr.setRequestHeader('X-CSRF-Token', token);
        if (beforeSend) return beforeSend.apply(this, arguments);
      };
    }
    // =========================================================================

    // Ensure that we have the appropriate request data.
    if (options.data == null && model && (method === 'create' || method === 'update' || method === 'patch')) {
      params.contentType = 'application/json';
      
      // =======================================================================
      // railsy_backbone
      // -----------------------------------------------------------------------
      // If model defines **paramRoot**, store model attributes within it. IE
      // 
      //   HTTP POST Parameters: { "book" => { "title" => "the illiad", "author" => "home" }}
      // 
      
      if(model.paramRoot) {
        var model_attributes = {}
        model_attributes[model.paramRoot] = model.toJSON(options);
        params.data = JSON.stringify(options.attrs || model_attributes );
      } else {
        params.data = JSON.stringify(options.attrs || model.toJSON(options) );
      }
      
      // -------------------------------------------------------------------------
      // original Backbone code
      //
      // params.data = JSON.stringify(options.attrs || model.toJSON(options) );
      //
      // =========================================================================
    }

    // For older servers, emulate JSON by encoding the request into an HTML-form.
    if (options.emulateJSON) {
      params.contentType = 'application/x-www-form-urlencoded';
      params.data = params.data ? {model: params.data} : {};
    }
    
    // For older servers, emulate HTTP by mimicking the HTTP method with `_method`
    // And an `X-HTTP-Method-Override` header.
    if (options.emulateHTTP && (type === 'PUT' || type === 'DELETE' || type === 'PATCH')) {
      params.type = 'POST';
      if (options.emulateJSON) params.data._method = type;
      var beforeSend = options.beforeSend;
      options.beforeSend = function(xhr) {
        xhr.setRequestHeader('X-HTTP-Method-Override', type);
        if (beforeSend) return beforeSend.apply(this, arguments);
      };
    }

    // Don't process data on a non-GET request.
    if (params.type !== 'GET' && !options.emulateJSON) {
      params.processData = false;
    }

    // If we're sending a `PATCH` request, and we're in an old Internet Explorer
    // that still has ActiveX enabled by default, override jQuery to use that
    // for XHR instead. Remove this line when jQuery supports `PATCH` on IE8.
    if (params.type === 'PATCH' && window.ActiveXObject &&
        !(window.external && window.external.msActiveXFilteringEnabled)) {
      params.xhr = function() {
        return new ActiveXObject("Microsoft.XMLHTTP");
      };
    }

    // Make the request, allowing the user to override any Ajax options.
    var xhr = options.xhr = Backbone.ajax(_.extend(params, options));
    model.trigger('request', model, xhr, options);
    return xhr;
  };

})(jQuery);
