require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new('spec') do |t|
  t.libs << 'lib' << 'spec'
  t.pattern = 'spec/tabula_rasa/*_spec.rb'
  t.verbose = true
end

desc 'Default: Run specs'
task :default => [:spec]
