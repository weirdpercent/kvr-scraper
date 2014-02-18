# -*- coding: utf-8 -*-
require 'json/add/core'
require 'json/pure'
require 'couchrest'
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
  def type(pdoc, formats)
    parsed=Parsed.new
    if parsed.vst(pdoc) != nil then formats.push "VST"; end
    if parsed.vst3(pdoc) != nil then formats.push "VST3"; end
    if parsed.au(pdoc) != nil then formats.push "Audio Unit"; end
    if parsed.dx(pdoc) != nil then formats.push "DirectX"; end
    if parsed.rtas(pdoc) != nil then formats.push "RTAS"; end
    if parsed.ladspa(pdoc) != nil then formats.push "LADSPA"; end
    if parsed.lv2(pdoc) != nil then formats.push "LV2"; end
    if parsed.rewire(pdoc) != nil then formats.push "ReWire"; end
    if parsed.aax(pdoc) != nil then formats.push "AAX"; end
    if parsed.dssi(pdoc) != nil then formats.push "DSSI"; end
    if parsed.re(pdoc) != nil then formats.push "Rack Extension"; end
  end
  def os(pdoc, platforms)
    parsed=Parsed.new
    if parsed.win(pdoc) != nil then platforms.push "Windows"; end
    if parsed.win64(pdoc) != nil then platforms.push "Windows x64"; end
    if parsed.mac(pdoc) != nil then platforms.push "Mac OSX"; end
    if parsed.mac64(pdoc) != nil then platforms.push "Mac x64"; end
    if parsed.lin(pdoc) != nil then platforms.push "Linux"; end
    if parsed.ios(pdoc) != nil then platforms.push "iOS"; end
    if parsed.droid(pdoc) != nil then platforms.push "Android"; end
  end
  def function(ptext, capabilities)
    txt=Txt.new
    if txt.inst(ptext) != nil then capabilities.push "Instrument"; end
    if txt.eff(ptext) != nil then capabilities.push "Effect"; end
    if txt.chinst(ptext) != nil then capabilities.push "Instrument Host"; end
    if txt.cheff(ptext) != nil then capabilities.push "Effect Host"; end
  end
end
print 'Stage two.'
lnk='plinks.txt'
plinks=File.readlines(lnk)
x=0
y=plinks.length
y-=1 #zero to y
while x <= y
  if x.to_s.length == 1 then filename="json/000#{x}.json"
  elsif x.to_s.length == 2 then filename="json/00#{x}.json"
  elsif x.to_s.length == 3 then filename="json/0#{x}.json"
  else filename="json/#{x}.json"
  end
  if FileTest.exist?(filename) == true
    print 'x'
    x+=1
  else
    formats=[]
    capabilities=[]
    platforms=[]
    query=plinks[x].chomp
    kvr=MetaInspector.new(query) #this data needs alot of work
    pdoc=kvr.parsed
    ptext=pdoc.text
    if ptext =~ /product is no longer listed at KVR Audio/ || pdoc.at_css('#pluginsblock div p') == nil
      ul=File.open('unlisted.txt', "a")
      ul.puts query
      ul.close
      print 'x'
      x+=1
    else
      pachinko=Pachinko.new
      pachinko.type(pdoc, formats)
      pachinko.os(pdoc, platforms)
      pachinko.function(ptext, capabilities)
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
      meta['productlink']=meta['external_links']
      meta['taglist']=meta['keywords']
      keyw=meta['taglist'].split(', ') #now only array in hash
      meta['taglist']=keyw
      meta['title']=meta['og:title']
      ntitle=meta['title'].gsub(/ -  Details/ , "")
      dsplit=ntitle.split(" by ") #take values and leave the rest
      meta['title']=dsplit[0].to_s
      meta['developer']=dsplit[1].to_s #new pair
      about=pdoc.at_css('#pluginsblock div p').text #better summary
      meta['summary']=about #replace with complete product info
      meta.delete('url')
      meta.delete('external_links')
      meta.delete('keywords')
      meta.delete('og:title')
      meta.delete('og:description') #ditch original keys
      meta=meta.sort #meta is now an array of arrays, unacceptable!
      title=meta.assoc('title')
      developer=meta.assoc('developer')
      link=meta.assoc('link')
      productlink=meta.assoc('productlink')
      summary=meta.assoc('summary')
      taglist=meta.assoc('taglist') #extract each from array
      ta=taglist[1].sort
      taglist[1]=ta
      newhash={}
      newhash['_id']=x.to_s
      newhash['title']=title[1] #assemble clean hash for JSON
      if capabilities.length > 1
        newhash['capabilities']=capabilities
      elsif capabilities.length == 1
        capabilities=capabilities[0].to_s
        newhash['capabilities']=capabilities
      else
        newhash['capabilities']=''
      end
      newhash['developer']=developer[1]
      if formats.length > 1
        newhash['formats']=formats
      elsif formats.length == 1
        formats=formats[0].to_s
      newhash['formats']=formats
      else
        newhash['formats']=''
      end
      newhash['link']=link[1]
      if platforms.length > 1 #so many conditions...
        newhash['platforms']=platforms
      elsif platforms.length == 1
        platforms=platforms[0].to_s
        newhash['platforms']=platforms
      else
        newhash['platforms']=''
      end
      ple=productlink[1]
      if ple.length == 1
        ple=ple[0].to_s
      end
      productlink[1]=ple
      newhash['productlink']=productlink[1]
      se=summary[1]
      se=se.gsub(/^\s*/, '')
      se=se.gsub(/\s*$/, '') #strip beginning and ending whitespace
      summary[1]=se
      newhash['summary']=summary[1]
      newhash['taglist']=taglist[1] #ugh, that was an ordeal
      tofile=JSON.generate(newhash)
      #tofile=JSON.pretty_generate(newhash) #make it more readable
      file=File.new(filename, "w+")
      file.print tofile #Et voilà! JSON-formatted product info.
      file.close
      x+=1
      print '.'
    end
  end
end
puts 'done.'
