// __NOTE:__ only overriding Backbone when `railsy_backbone (start) ... (end)` 
// is explicitly called out.
// 
// Before addign this to the repo, I'd like to enable a configuration value to 
// turn this feature on and off
// 
// 
// (function($) {
//   return $.extend($.fn, {
//     backboneLink: function(model) {
//       return $(this).find(":input").each(function() {
//         var el, name;
//         el = $(this);
//         name = el.attr("name");
//         model.bind("change:" + name, function() {
//           return el.val(model.get(name));
//         });
//         return $(this).bind("change", function() {
//           var attrs;
//           el = $(this);
//           attrs = {};
//           attrs[el.attr("name")] = el.val();
//           return model.set(attrs);
//         });
//       });
//     }
//   });
// })(jQuery);
