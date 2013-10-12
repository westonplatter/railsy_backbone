require 'test_helper'
require 'generators/generators_test_helper'
require 'generators/backbone/scaffold/scaffold_generator'

class ScaffoldGeneratorTest < Rails::Generators::TestCase
  include GeneratorsTestHelper
  tests Backbone::Generators::ScaffoldGenerator
  arguments %w(Book title:string author:string)
  
  test "generate router scaffolding" do
    run_generator
    
    assert_file "#{backbone_path}/routers/books_router.js.coffee" do |router|
      assert_match /class Dummy.Routers.BooksRouter extends Backbone.Router/, router
      assert_match /newBook: ->/, router
      assert_match /@books.reset options.books/, router
      
      %w(NewView IndexView ShowView EditView).each do |view|
        assert_match /new Dummy.Views.Books.#{view}/, router
      end
    end
  end
  
  test "generate router scaffolding for model with two words" do
    run_generator %w(OldBook title:string author:string)
    
    assert_file "#{backbone_path}/routers/old_books_router.js.coffee" do |router|
      assert_match /class Dummy.Routers.OldBooksRouter extends Backbone.Router/, router
      assert_match /newOldBook: ->/, router
      assert_match /@oldBooks.reset options.oldBooks/, router
      
      %w(NewView IndexView ShowView EditView).each do |view|
        assert_match /new Dummy.Views.OldBooks.#{view}/, router
      end
    end
  end
  
  test "generate view files" do
    run_generator
    
    assert_file "#{backbone_path}/views/books/index_view.js.coffee" do |view|
      assert_match /#{Regexp.escape('JST["backbone/templates/books/index"]')}/, view
      assert_match /#{Regexp.escape('@template(books: @collection.toJSON() ))')}/, view
      assert_match /#{Regexp.escape("new Dummy.Views.Books.BookView({model : book})")}/, view
    end
    
    assert_file "#{backbone_path}/views/books/show_view.js.coffee" do |view|
      assert_match /class Dummy.Views.Books.ShowView extends Backbone.View/, view
      assert_match /#{Regexp.escape('@template(@model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('template: JST["backbone/templates/books/show"]')}/, view
    end
    
    assert_file "#{backbone_path}/views/books/new_view.js.coffee" do |view|
      assert_match /class Dummy.Views.Books.NewView extends Backbone.View/, view
      assert_match /#{Regexp.escape('@template(@model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('JST["backbone/templates/books/new"]')}/, view
      assert_match /#{Regexp.escape('"submit #new-book": "save"')}/, view
      assert_match /#{Regexp.escape('success: (book) =>')}/, view
      assert_match /#{Regexp.escape('@model = book')}/, view
    end
    
    assert_file "#{backbone_path}/views/books/edit_view.js.coffee" do |view|
      assert_match /class Dummy.Views.Books.EditView extends Backbone.View/, view
      assert_match /#{Regexp.escape('JST["backbone/templates/books/edit"]')}/, view
      assert_match /#{Regexp.escape('"submit #edit-book": "update"')}/, view
      assert_match /#{Regexp.escape('success: (book) =>')}/, view
    end
    
    assert_file "#{backbone_path}/views/books/book_view.js.coffee" do |view|
      assert_match /class Dummy.Views.Books.BookView extends Backbone.View/, view
      assert_match /#{Regexp.escape('@template(@model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('JST["backbone/templates/books/book"]')}/, view
    end
  end
  
  test "generate view files for model with two words" do
    run_generator %w(OldBook title:string author:string)
    
    assert_file "#{backbone_path}/views/old_books/index_view.js.coffee" do |view|
      assert_match /#{Regexp.escape('JST["backbone/templates/old_books/index"]')}/, view
      assert_match /#{Regexp.escape('@template(oldBooks: @collection.toJSON() ))')}/, view
      assert_match /#{Regexp.escape("new Dummy.Views.OldBooks.OldBookView({model : oldBook})")}/, view
    end
    
    assert_file "#{backbone_path}/views/old_books/show_view.js.coffee" do |view|
      assert_match /class Dummy.Views.OldBooks.ShowView extends Backbone.View/, view
      assert_match /#{Regexp.escape('@template(@model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('template: JST["backbone/templates/old_books/show"]')}/, view
    end
    
    assert_file "#{backbone_path}/views/old_books/new_view.js.coffee" do |view|
      assert_match /class Dummy.Views.OldBooks.NewView extends Backbone.View/, view
      assert_match /#{Regexp.escape('@template(@model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('JST["backbone/templates/old_books/new"]')}/, view
      assert_match /#{Regexp.escape('"submit #new-old_book": "save"')}/, view
      assert_match /#{Regexp.escape('success: (old_book) =>')}/, view
      assert_match /#{Regexp.escape('@model = old_book')}/, view
    end
    
    assert_file "#{backbone_path}/views/old_books/edit_view.js.coffee" do |view|
      assert_match /class Dummy.Views.OldBooks.EditView extends Backbone.View/, view
      assert_match /#{Regexp.escape('template: JST["backbone/templates/old_books/edit"]')}/, view
      assert_match /#{Regexp.escape('"submit #edit-old_book": "update"')}/, view
      assert_match /#{Regexp.escape('success: (old_book) =>')}/, view
      assert_match /#{Regexp.escape('events:')}/, view
      assert_match /#{Regexp.escape('update: (e) ->')}/, view
      assert_match /#{Regexp.escape('render: ->')}/, view
    end
    
    assert_file "#{backbone_path}/views/old_books/old_book_view.js.coffee" do |view|
      assert_match /class Dummy.Views.OldBooks.OldBookView extends Backbone.View/, view
      assert_match /#{Regexp.escape('@template(@model.toJSON() )')}/, view
      assert_match /#{Regexp.escape('JST["backbone/templates/old_books/old_book"]')}/, view
    end
  end
  
  test "generate template files" do
    run_generator
     
    assert_file "#{backbone_path}/templates/books/index.jst.ejs"
    
    assert_file "#{backbone_path}/templates/books/new.jst.ejs" do |view|
      assert_match /#{Regexp.escape('<form id="new-book" name="book">')}/, view
      assert_match /#{Regexp.escape('<input type="text" name="title" id="title" value="<%= title %>" >')}/, view
      assert_match /#{Regexp.escape('<input type="text" name="author" id="author" value="<%= author %>" >')}/, view
    end
    
    assert_file "#{backbone_path}/templates/books/edit.jst.ejs" do |view|
      assert_match /#{Regexp.escape('<form id="edit-book" name="book">')}/, view
      assert_match /#{Regexp.escape('<input type="text" name="title" id="title" value="<%= title %>" >')}/, view
      assert_match /#{Regexp.escape('<input type="text" name="author" id="author" value="<%= author %>" >')}/, view
    end
    
    assert_file "#{backbone_path}/templates/books/show.jst.ejs"
    assert_file "#{backbone_path}/templates/books/book.jst.ejs"
  end
   
  test "generate template files for model with two words" do
    run_generator %w(OldBook title:string author:string)

    assert_file "#{backbone_path}/templates/old_books/index.jst.ejs"

    assert_file "#{backbone_path}/templates/old_books/new.jst.ejs" do |view|
      assert_match /#{Regexp.escape('<form id="new-old_book" name="old_book">')}/, view
    end

    assert_file "#{backbone_path}/templates/old_books/edit.jst.ejs" do |view|
      assert_match /#{Regexp.escape('<form id="edit-old_book" name="old_book">')}/, view
    end

    assert_file "#{backbone_path}/templates/old_books/show.jst.ejs"
    assert_file "#{backbone_path}/templates/old_books/old_book.jst.ejs"
  end
   
  test "backbone model generator is invoked" do
    run_generator
    
    assert_file "#{backbone_path}/models/book.js.coffee" do |model|
      assert_match /url: '\/books'/, model
      assert_match /paramRoot: 'book'/, model
      
      assert_match /title: null/, model
      assert_match /author: null/, model
    end
  end
  
  test "backbone model generator is invoked for model with two words" do
    run_generator %w(OldBook title:string author:string)
    
    assert_file "#{backbone_path}/models/old_book.js.coffee" do |model|
      assert_match /url: '\/old_books'/, model
      assert_match /paramRoot: 'old_book'/, model
      
      assert_match /title: null/, model
      assert_match /author: null/, model
    end
  end
  
end

