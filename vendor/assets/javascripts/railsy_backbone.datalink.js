// __NOTE:__ only overriding Backbone when `railsy_backbone (start) ... (end)` 
// is explicitly called out.
// 
// TODO
// Enable a configuration value to turn this feature on/off

(function($) {
  
  // `$.extend` enables us to chain functions onto jQuery selected DOM elements.
  // For example, 
  // 
  //     this.$("form").backboneLink(@model)
  // 
  return $.extend($.fn, {
    
    // name function `backboneLine`
    backboneLink: function(model) {
      
      // only target HTML input elements
      return $(this).find(":input").each(function() {
        var el, name;
        el = $(this);
        
        // select the HTML input `name` attribute
        name = el.attr("name");
        
        // TODO describe what this does
        model.bind("change:" + name, function() {
          return el.val(model.get(name));
        });
        
        // re-set model specifical attribute when changed
        return $(this).bind("change", function() {
          var attrs;
          el = $(this);
          attrs = {};
          attrs[el.attr("name")] = el.val();
          return model.set(attrs);
        });
      });
    }
  });
})(jQuery);
