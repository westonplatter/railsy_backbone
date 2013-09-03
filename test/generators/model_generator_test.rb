require 'test_helper'
require 'generators/generators_test_helper'
require "generators/backbone/model/model_generator"

class ModelGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper
  tests Backbone::Generators::ModelGenerator
  
  test "simple model" do
    run_generator %w(Book title:string author:string)
    
    assert_file "#{backbone_path}/models/book.js.coffee" do |model|
      model_class = Regexp.escape("class Dummy.Models.Book extends Backbone.Model")
      collection_class = Regexp.escape("class Dummy.Collections.BooksCollection extends Backbone.Collection")
      
      assert_match /#{model_class}/, model
      assert_match /#{collection_class}/, model
      
      assert_match /paramRoot: 'book'/, model
      assert_match /url: '\/books'/, model
      
      assert_match /defaults:/, model
      assert_match /title: null/, model
      assert_match /author: null/, model
    end
    
  end
  
  test "two word model is camelcased" do
    run_generator %w(OldBook title:string author:string)
    
    assert_file "#{backbone_path}/models/old_book.js.coffee" do |model|
      model_class = Regexp.escape("class Dummy.Models.OldBook extends Backbone.Model")
      collection_class = Regexp.escape("class Dummy.Collections.OldBooksCollection extends Backbone.Collection")
      
      assert_match /#{model_class}/, model
      assert_match /#{collection_class}/, model
      
      assert_match /paramRoot: 'old_book'/, model
      assert_match /url: '\/old_books'/, model
      
      assert_match /defaults:/, model
      assert_match /title: null/, model
      assert_match /author: null/, model
    end
    
  end
  
end
