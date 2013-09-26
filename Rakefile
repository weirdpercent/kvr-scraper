require 'rake/clean'

task :clean do
  CLEAN = FileList['**/*.json']
  puts 'JSON cleaned.'
end

task :clobber do
  CLOBBER = FileList['**/*.json', 'plinks.txt']
  puts 'Everything cleaned.'
end

desc "Parse JSON files"
task :parse do
  require './parse.rb'
end

desc "Run all"
task :run do
  puts 'Running all stages:'
  require './scrape1.rb'
  require './scrape2.rb'
  require './parse.rb'
end

task :default => :run

desc "Stage one"
task :one do
  require './scrape1.rb'
end

desc "Stage two"
task :two do
  require './scrape2.rb'
end

desc "Scrape to JSON"
task :scrape do
  require './scrape1.rb'
  require './scrape2.rb'
end
