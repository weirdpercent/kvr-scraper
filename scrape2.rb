require 'json'
require 'json/pure'
require 'metainspector'
print 'Stage Two'
lnk='plinks.txt'
plinks=File.readlines(lnk)
x=0
y=plinks.length
y-=1 #zero to y
while x <= y
  query=plinks.fetch(x)
  query.chomp
  kvr=MetaInspector.new(query)
  hash=kvr.to_hash
  tofile=JSON.pretty_generate(hash)
  filename="json/#{x}.json"
  file=File.new(filename, "w+")
  file.print tofile
  file.close
  x+=1
  print '.'
end
puts 'done.'
