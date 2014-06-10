require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rdoc/task'
require 'rake/testtask'

task :default => :test

Rake::RDocTask.new do |rdoc|
  files =['README.rdoc', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README.rdoc" # page to start on
  rdoc.title = "SAML Tools Documentation"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
end

task :console do
  require 'irb'
  require 'irb/completion'
  require_relative 'lib/saml_tool'
  ARGV.clear
  IRB.start
end
