require 'json/add/core'
require 'json/pure'
require 'metainspector'
print 'Stage two'
lnk='plinks.txt'
plinks=File.readlines(lnk)
x=0
y=plinks.length
y-=1 #zero to y
while x <= y
  query=plinks[x]
  query.chomp
  kvr=MetaInspector.new(query)
  pdoc=kvr.parsed_document
  hash=kvr.to_hash #great start, but it needs alot of work
  hash.delete('title')
  hash.delete('links')
  hash.delete('internal_links')
  hash.delete('images')
  hash.delete('charset')
  hash.delete('feed')
  hash.delete('content_type') #see what I mean?
  meta=hash['meta']
  hash.delete('meta')
  name=meta['name'] #now these elements are accessible
  name.delete('description')
  name.delete('og:image')
  name.delete('msapplication_tilecolor')
  name.delete('msapplication_tileimage')
  meta=hash.merge(name) #and all elements together
  meta['link']=meta['url']
  meta['plink']=meta['external_links']
  ext=meta['plink'].last
  meta['plink']=ext
  meta['tags']=meta['keywords']
  keyw=meta['tags'].split(', ') #now only array in hash
  meta['tags']=keyw
  meta['atitle']=meta['og:title'] 
  ntitle=meta['atitle'].gsub(/ -  Details/, '')
  meta['atitle']=ntitle
  dsplit=meta['atitle'].split(/ by /) #take values and leave the rest
  meta['atitle']=dsplit[0].to_s
  meta['dev']=dsplit[1].to_s #new pair
  meta['summary']=meta['og:description']
  about=pdoc.at_css('.kvrproductimages').parent.text #Nokogiri hack
  meta['summary']=about #replace with complete product info
  meta.delete('url')
  meta.delete('external_links')
  meta.delete('keywords')
  meta.delete('og:title')
  meta.delete('og:description') #ditch original keys
  meta=meta.sort #ugh, that was an ordeal
  tofile=JSON.pretty_generate(meta)
  filename="json/#{x}.json"
  file=File.new(filename, "w+")
  file.print tofile
  file.close
  x+=1
  print '.'
end
puts 'done.'
