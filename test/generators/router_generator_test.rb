require 'test_helper'
require 'generators/generators_test_helper'
require "generators/backbone/router/router_generator"

class RouterGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper
  tests Backbone::Generators::RouterGenerator
  
  test "simple router with two actions" do
    run_generator ["Books", "index", "edit"]
    
    assert_file "#{backbone_path}/routers/books_router.js.coffee" do |router|
      assert_match /Dummy.Routers.BooksRouter extends Backbone.Router/, router
    end
    
    %W{index edit}.each do |action|
      assert_file "#{backbone_path}/views/books/#{action}_view.js.coffee"
      assert_file "#{backbone_path}/templates/books/#{action}.jst.ejs"
    end
  end
  
  test "camelize router names containing two words" do
    run_generator ["OldBooks", "index", "edit"]
    
    assert_file "#{backbone_path}/routers/old_books_router.js.coffee" do |router|
      assert_match /Dummy.Routers.OldBooksRouter extends Backbone.Router/, router
    end
    
    %W{index edit}.each do |action|
      assert_file "#{backbone_path}/views/old_books/#{action}_view.js.coffee"
      assert_file "#{backbone_path}/templates/old_books/#{action}.jst.ejs"
    end
  end
  
  test "raises an error when an action is a javascript reserved word" do
    content = capture(:stderr){ run_generator ["Posts", "new"] }
    assert_equal "The name 'new' is reserved by javascript Please choose an alternative action name and run this generator again.\n", content
  end
  
end
