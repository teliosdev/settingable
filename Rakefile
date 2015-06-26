# encoding: utf-8
# rubocop:disable Style/HashSyntax
require "rake"
require "yard"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new
YARD::Rake::YardocTask.new

task :test => :spec
task :default => :spec
task :doc => :yard
