require 'rake/testtask'
require 'sinatra/activerecord/rake'
require './app'

task :default => :spec

desc "Run all tests"
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end
