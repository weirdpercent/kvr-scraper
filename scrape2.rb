require 'json'
require 'metainspector'
print 'Stage Two'
lnk='plinks.txt'
plinks=File.readlines(lnk)
x=0
y=plinks.length
y=y-1
while x <= y
  query=plinks.fetch(x)
  query.chomp
  kvr=MetaInspector.new(query)
  hash=kvr.to_hash
  filename="json/#{x}.json"
  x+=1
  file=File.new(filename, "w+")
  file.print hash
  file.close
  print '.'
end
puts 'done.'
