require 'json'
require 'metainspector'
print 'Stage Two'
lnk='plinks.txt'
plinks=File.readlines(lnk)
x=1
y=plinks.length
while x <= y
  query=plinks[x.to_i]
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
