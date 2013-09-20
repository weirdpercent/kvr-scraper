require 'metainspector'

class Proc
  def initialize(plinks.txt)
    print 'Processing plinks.txt'
    filename='plinks.txt'
    tmp='tmp.txt'
    plinks=File.readlines(filename) #read each product URL into ary
    query=plinks[0]
    kvr=MetaInspector.new(query) #crawl product URL
    doc=kvr.document
    pdoc=kvr.parsed_document
    ptxt=pdoc.text
    data=ptxt.split
    w=data.index('(MSRP)') #find MSRP string
    w=w-5 #go back 5 lines
    hash={} #read k/v pairs into hash
    pair=[]
    prodkey=data.fetch(w)
    w += 1
    prodval=data.fetch(w)
    hash[prodkey]=prodval
    w += 1
    devkey=data.fetch(w)
    w += 1
    devval=data.fetch(w)
    hash[devkey]=devval
    pricekey='Price'
    if data.fetch(w) == 'No'
      priceval='No Longer Available'
      w+=9
    else
      priceval=data.fetch(w)
      w+=7
    end
    hash[pricekey]=priceval
    w += 1
    tagkey='Tags'
    w += 1
    tagval=data.fetch(w)
    hash[tagkey]=tagval
    w += 8
    if data.fetch(w) =~ /Instrument/
      fmtkey='Instrument'
    elsif data.fetch(w) =~ /Effect/
      fmtkey='Effect'
    end
    temp=File.new(tmp, "a")
    temp.print "#{@hash}\n"
    temp.close
  end 
end
