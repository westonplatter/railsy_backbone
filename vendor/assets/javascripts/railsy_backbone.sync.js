// __NOTE:__ only overriding Backbone when `railsy_backbone (start) ... (end)` 
// is explicitly called out.
// 
// Overriding Backbone.sync to implement,  
// - Nested model attributes  
// - Rails CSFR Integration  
// 
( function($){
  
  // Define `methodMap` since it's called from within Backbone.sync
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
    
    // -------------------------------------------------------------------------
    // railsy_backbone (start)  
    // __Rails CSFR Integration__  
    // 
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
    // railsy_backbone (end)
    // 
    // -------------------------------------------------------------------------

    // Ensure that we have the appropriate request data.
    if (options.data == null && model && (method === 'create' || method === 'update' || method === 'patch')) {
      params.contentType = 'application/json';
      
      // -----------------------------------------------------------------------
      // railsy_backbone (start)  
      // __Nested Model Attributes__  
      // 
      // If Backbone.Model defines `paramRoot`, then store model attributes 
      // within `paramRoot` key-value pair. For example, book attributes 
      // (`title`, `author`) are nested within `book` key-value pair,
      // 
      //      var Book = Backbone.Model.extend({ 
      //        url: '/books',
      //        paramRoot: 'book' 
      //      });
      // 
      //      var book_instance = new Book({ 
      //        title:  'the illiad', 
      //        author: 'homer'
      //      });
      // 
      // The resulting HTTP POST looks like this,
      // 
      //      book_instance.sync();
      // 
      //      Started POST "/books" for 127.0.0.1
      //        Processing by BooksController#create as JSON
      //        { "book" => { "title" => "the illiad", "author" => "home" } }
      // 
      if(model.paramRoot) {        
        var model_attributes = {}
        
        // Store model instance in JSON format.
        var attrs = model.toJSON(options);
        
        // Remove Rails unofficially reserved `created_at` and `updated_at` so 
        // they're included in HTTP PUT/PATCH request.
        delete attrs["created_at"];
        delete attrs["updated_at"];
        
        // Nest model attributes within model's `paramRoot` key-value pair.
        model_attributes[model.paramRoot] = attrs;
        
        params.data = JSON.stringify(options.attrs || model_attributes);
      } else {
        // If model does not define a `paramRoot`, use the original Backbone 
        // implementation
        params.data = JSON.stringify(options.attrs || model.toJSON(options) );
      }
      // railsy_backbone (end)  
      // 
      // -----------------------------------------------------------------------
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
