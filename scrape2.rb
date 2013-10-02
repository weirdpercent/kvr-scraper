require 'json/add/core'
require 'json/pure'
require 'metainspector'
class Parsed #The dreaded CSS selector class! Why did KVR have to use images?!
  def win(pdoc)
    pdoc.at_css(".sp1b")
  end
  def win64(pdoc)
    pdoc.at_css(".sp2b")
  end
  def mac(pdoc)
    pdoc.at_css(".sp3b")
  end
  def mac64(pdoc)
    pdoc.at_css(".sp6b")
  end
  def lin(pdoc)
    pdoc.at_css(".sp7b")
  end
  def ios(pdoc)
    pdoc.at_css(".sp14b")
  end
  def droid(pdoc)
    pdoc.at_css(".sp15b")
  end
  def vst(pdoc)
    pdoc.at_css(".sp20b")
  end
  def vst3(pdoc)
    pdoc.at_css(".sp21b")
  end
  def au(pdoc)
    pdoc.at_css(".sp22b")
  end
  def dx(pdoc)
    pdoc.at_css(".sp23b")
  end
  def rtas(pdoc)
    pdoc.at_css(".sp24b")
  end
  def ladspa(pdoc)
    pdoc.at_css(".sp25b")
  end
  def lv2(pdoc)
    pdoc.at_css(".sp26b")
  end
  def rewire(pdoc)
    pdoc.at_css(".sp27b")
  end
  def aax(pdoc)
    pdoc.at_css(".sp29b")
  end
  def dssi(pdoc)
    pdoc.at_css(".sp30b")
  end
  def re(pdoc)
    pdoc.at_css(".sp31b")
  end
end
class Txt
  def inst(ptext)
    ptext =~ /Instrument\(s\)/
  end
  def eff(ptext)
    ptext =~ /Effect\(s\)/
  end
  def chinst(ptext)
    ptext =~ /Can HostInstruments/
  end
  def cheff(ptext)
    ptext =~ /Can HostEffects/
  end
end
class Pachinko #Ever played Pachinko?
  def type(pdoc, format)
    parsed=Parsed.new
    if parsed.vst(pdoc) != nil then format.push "VST"; end
    if parsed.vst3(pdoc) != nil then format.push "VST3"; end
    if parsed.au(pdoc) != nil then format.push "Audio Unit"; end
    if parsed.dx(pdoc) != nil then format.push "DirectX"; end
    if parsed.rtas(pdoc) != nil then format.push "RTAS"; end
    if parsed.ladspa(pdoc) != nil then format.push "LADSPA"; end
    if parsed.lv2(pdoc) != nil then format.push "LV2"; end
    if parsed.rewire(pdoc) != nil then format.push "ReWire"; end
    if parsed.aax(pdoc) != nil then format.push "AAX"; end
    if parsed.dssi(pdoc) != nil then format.push "DSSI"; end
    if parsed.re(pdoc) != nil then format.push "Rack Extension"; end
  end
  def platform(pdoc, os)
    parsed=Parsed.new
    if parsed.win(pdoc) != nil then os.push "Windows"; end
    if parsed.win64(pdoc) != nil then os.push "Windows x64"; end
    if parsed.mac(pdoc) != nil then os.push "Mac OSX"; end
    if parsed.mac64(pdoc) != nil then os.push "Mac x64"; end
    if parsed.lin(pdoc) != nil then os.push "Linux"; end
    if parsed.ios(pdoc) != nil then os.push "iOS"; end
    if parsed.droid(pdoc) != nil then os.push "Android"; end
  end
  def function(ptext, cando)
    txt=Txt.new
    if txt.inst(ptext) != nil then cando.push "Instrument"; end
    if txt.eff(ptext) != nil then cando.push "Effect"; end
    if txt.chinst(ptext) != nil then cando.push "Instrument Host"; end
    if txt.cheff(ptext) != nil then cando.push "Effect Host"; end
  end
end
print 'Stage two'
lnk='plinks.txt'
plinks=File.readlines(lnk)
x=0
y=plinks.length
y-=1 #zero to y
while x <= y
  format=[]
  cando=[]
  os=[]
  query=plinks[x].chomp
  kvr=MetaInspector.new(query) #this data needs alot of work
  pdoc=kvr.parsed_document
  ptext=pdoc.text
  pachinko=Pachinko.new
  pachinko.type(pdoc, format)     #100 lines
  pachinko.platform(pdoc, os)     #of code
  pachinko.function(ptext, cando) #in 3 method calls
  hash=kvr.to_hash
  hash.delete('title')
  hash.delete('links')
  hash.delete('internal_links')
  hash.delete('images')
  hash.delete('charset')
  hash.delete('feed')
  hash.delete('content_type')
  meta=hash['meta']
  hash.delete('meta')
  name=meta['name']
  name.delete('description')
  name.delete('og:image')
  name.delete('msapplication_tilecolor')
  name.delete('msapplication_tileimage')
  extr=hash['external_links']
  extr=extr.reject {|url| url =~ /KVR-Audio/}
  extr=extr.reject {|url| url =~ /kvraudio/}
  hash['external_links']=extr
  meta=hash.merge(name)
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
  about=pdoc.at_css('.kvrproductimages').parent.text #better summary
  meta['summary']=about #replace with complete product info
  meta.delete('url')
  meta.delete('external_links')
  meta.delete('keywords')
  meta.delete('og:title')
  meta.delete('og:description') #ditch original keys
  meta=meta.sort #meta is now an array of arrays, unacceptable!
  atitle=meta.assoc('atitle')
  dev=meta.assoc('dev')
  link=meta.assoc('link')
  plink=meta.assoc('plink')
  summary=meta.assoc('summary')
  tags=meta.assoc('tags') #extract each from array
  newhash={}
  newhash['atitle']=atitle[1] #assemble clean hash for JSON
  if cando.length > 1
    newhash['cando']=cando
  elsif cando.length == 1
    cando=cando[0].to_s
    newhash['cando']=cando
  else
    newhash['cando']=''
  end
  newhash['dev']=dev[1]
  if format.length > 1
    newhash['format']=format
  elsif format.length == 1
    format=format[0].to_s
    newhash['format']=format
  else
    newhash['format']=''
  end
  newhash['link']=link[1]
  if os.length > 1 #so many conditions...
    newhash['os']=os
  elsif os.length == 1
    os=os[0].to_s
    newhash['os']=os
  else
    newhash['os']=''
  end
  ple=plink[1]
  if ple.length == 1
    ple=ple[0].to_s
  end
  plink[1]=ple
  newhash['plink']=plink[1]
  se=summary[1]
  se=se.gsub(/^\s*/, '')
  se=se.gsub(/\s*$/, '') #strip beginning and ending whitespace
  summary[1]=se
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
