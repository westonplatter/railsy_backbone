#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

ENV['DUMMY_PATH'] = 'test/dummy'
# ENV['ENGINE']
# ENV['TEMPLATE']
require 'rails/dummy/tasks'

require 'bundler/gem_tasks'

namespace :backbone do
  desc "Download the latest released versions of underscore and backbone.js"
  task :download_latest do
    files = {
      'underscore.js'=>'http://underscorejs.org/underscore.js',
      'backbone.js' => 'http://backbonejs.org/backbone.js'
    }
    
    vendor_dir = "vendor/assets/javascripts"

    require 'open-uri'
    files.each do |local,remote|
      puts "Downloading #{local}"
      File.open "#{vendor_dir}/#{local}", 'w' do |f|
        f.write open(remote).read
      end
    end
  end
end


# Check for the existence of an executable.
def check(exec, name, url)
  return unless `which #{exec}`.empty?
  puts "#{name} not found.\nInstall it from #{url}"
  exit
end

desc 'build the docco documentation'
task :doc do
  check 'groc', 'groc', 'https://github.com/nevir/groc'
  system 'groc'
end

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test
