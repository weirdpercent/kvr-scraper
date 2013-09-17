require 'metainspector'
# this script adds a product link to a text file for each free product on kvr
def process(query)
end

query='http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t'
kvr=MetaInspector.new(query) # crawl kvr query
kvrlinks=kvr.links # just the links
plinks=[]
pnames=[]
kvrlinks.each do |x|
  if x =~ /\d*\/reviews/ # if it's a review link
      kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /developer/ #if it's a developer link
   kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /product/
    plinks.push x
  end
end
filename="plinks.txt"
file=File.new(filename, "a")
plinks.each do |x|
  prefix=x.gsub(/http:\/\/www.kvraudio.com\/product\//, "") # strip URL before product name
  suffix=prefix.gsub(/-by-\w*/, "") # strip developer
  name=suffix.gsub(/\/review\/\d{4}/, "") # strip reviews
  pnames.push name # push it to pnames
  file.print "#{x}\n"
end
file.close
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=500"
kvr=MetaInspector.new(query) # 2nd page
kvrlinks=kvr.links # just the links
plinks=[]
pnames=[]
kvrlinks.each do |x|
  if x =~ /\d*\/reviews/ # if it's a review link
      kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /developer/ #if it's a developer link
   kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /product/
    plinks.push x
  end
end
file=File.open(filename, "a")
plinks.each do |x|
  prefix=x.gsub(/http:\/\/www.kvraudio.com\/product\//, "") # strip URL before product name
  suffix=prefix.gsub(/-by-\w*/, "") # strip developer
  name=suffix.gsub(/\/review\/\d{4}/, "") # strip reviews
  pnames.push name # push it to pnames
  file.print "#{x}\n"
end
file.close
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=1000"
kvr=MetaInspector.new(query) # 3rd page
kvrlinks=kvr.links # just the links
plinks=[]
pnames=[]
kvrlinks.each do |x|
  if x =~ /\d*\/reviews/ # if it's a review link
      kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /developer/ #if it's a developer link
   kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /product/
    plinks.push x
  end
end
file=File.open(filename, "a")
plinks.each do |x|
  prefix=x.gsub(/http:\/\/www.kvraudio.com\/product\//, "") # strip URL before product name
  suffix=prefix.gsub(/-by-\w*/, "") # strip developer
  name=suffix.gsub(/\/review\/\d{4}/, "") # strip reviews
  pnames.push name # push it to pnames
  file.print "#{x}\n"
end
file.close
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=1500"
kvr=MetaInspector.new(query) # 4th page
kvrlinks=kvr.links # just the links
plinks=[]
pnames=[]
kvrlinks.each do |x|
  if x =~ /\d*\/reviews/ # if it's a review link
      kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /developer/ #if it's a developer link
   kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /product/
    plinks.push x
  end
end
file=File.open(filename, "a")
plinks.each do |x|
  prefix=x.gsub(/http:\/\/www.kvraudio.com\/product\//, "") # strip URL before product name
  suffix=prefix.gsub(/-by-\w*/, "") # strip developer
  name=suffix.gsub(/\/review\/\d{4}/, "") # strip reviews
  pnames.push name # push it to pnames
  file.print "#{x}\n"
end
file.close
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=2000"
kvr=MetaInspector.new(query) # 5th page
kvrlinks=kvr.links # just the links
plinks=[]
pnames=[]
kvrlinks.each do |x|
  if x =~ /\d*\/reviews/ # if it's a review link
      kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /developer/ #if it's a developer link
   kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /product/
    plinks.push x
  end
end
file=File.open(filename, "a")
plinks.each do |x|
  prefix=x.gsub(/http:\/\/www.kvraudio.com\/product\//, "") # strip URL before product name
  suffix=prefix.gsub(/-by-\w*/, "") # strip developer
  name=suffix.gsub(/\/review\/\d{4}/, "") # strip reviews
  pnames.push name # push it to pnames
  file.print "#{x}\n"
end
file.close
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=2500"
kvr=MetaInspector.new(query) # 6th page
kvrlinks=kvr.links # just the links
plinks=[]
pnames=[]
kvrlinks.each do |x|
  if x =~ /\d*\/reviews/ # if it's a review link
      kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /developer/ #if it's a developer link
   kvrlinks.delete(x)
  end
end
kvrlinks.each do |x|
  if x =~ /product/
    plinks.push x
  end
end
file=File.open(filename, "a")
plinks.each do |x|
  prefix=x.gsub(/http:\/\/www.kvraudio.com\/product\//, "") # strip URL before product name
  suffix=prefix.gsub(/-by-\w*/, "") # strip developer
  name=suffix.gsub(/\/review\/\d{4}/, "") # strip reviews
  pnames.push name # push it to pnames
  file.print "#{x}\n"
end
file.close