require 'json'
require 'json/pure'
#require 'couchrest'
print 'Parsing'
fa=[]
Dir.glob('*').select {|f| fa.push f}
fa.each do |x|
  if x == 'parse.rb'
    fa.delete(x) #only json files
  end
end
fa.sort_by {|e| e[/\d+/].to_i}
hash={}
fa.each do |x|
  file=File.readlines(x)
  hash[x.to_i]=JSON.parse(file.join)
  print '.'
end
puts 'done.'
