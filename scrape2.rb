require 'json/add/core'
require 'json/pure'
require 'couchrest'
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
  extr=hash['external_links']
  extr=extr.reject {|url| url =~ /KVR-Audio/}
  extr=extr.reject {|url| url =~ /kvraudio/}
  hash['external_links']=extr
  meta=hash.merge(name) #and all elements together
  meta['link']=meta['url']
  meta['plink']=meta['external_links']
  meta['tags']=meta['keywords']
  keyw=meta['tags'].split(', ') #now only array in hash
  meta['tags']=keyw
  meta['atitle']=meta['og:title'] 
  ntitle=meta['atitle'].gsub(/ -  Details/, '')
  dsplit=ntitle.split(/ by /) #take values and leave the rest
  meta['atitle']=dsplit[0].to_s
  meta['dev']=dsplit[1].to_s #new pair
  about=pdoc.at_css('.kvrproductimages').parent.text #Nokogiri hack
  meta['summary']=about #replace with complete product info
  meta.delete('url')
  meta.delete('external_links')
  meta.delete('keywords')
  meta.delete('og:title')
  meta.delete('og:description') #ditch original keys
  meta=meta.sort #meta is now an array of arrays, that won't do
  atitle=meta.assoc('atitle')
  dev=meta.assoc('dev')
  link=meta.assoc('link')
  plink=meta.assoc('plink')
  summary=meta.assoc('summary')
  tags=meta.assoc('tags') #extract each from array
  newhash={}
  newhash['atitle']=atitle[1] #nice clean hash to_json
  newhash['dev']=dev[1]
  newhash['link']=link[1]
  newhash['plink']=plink[1]
  newhash['summary']=summary[1]
  newhash['tags']=tags[1] #ugh, that was an ordeal
  tofile=JSON.pretty_generate(newhash) #make it more readable
  filename="json/#{x}.json"
  file=File.new(filename, "w+")
  file.print tofile #Et voilà! Product info in JSON format.
  file.close
  x+=1
  print '.'
end
puts 'done.'
