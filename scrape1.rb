require 'metainspector'
# this script adds a product link to a text file for each free product on kvr
print 'Stage One'
class First
  def kvrquery(query)
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
    filename="alllinks.txt" #write to big list of 2500+ products
    if File.exist?(filename) == true
      file=File.open(filename, "a")
    else
      file=File.new(filename, "w+")
    end
    plinks.each do |x|
      prefix=x.gsub(/http:\/\/www.kvraudio.com\/product\//, "") # strip URL before product name
      suffix=prefix.gsub(/-by-\w*/, "") # strip developer
      name=suffix.gsub(/\/review\/\d{4}/, "") # strip reviews
      pnames.push name # push it to pnames
      file.print "#{x}\n"
    end
    file.close
  end
end
print '.'
Scraper=First.new()
query='http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t'
print '.'
Scraper.kvrquery(query)
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=500"
print '.'
Scraper.kvrquery(query)
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=1000"
print '.'
Scraper.kvrquery(query)
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=1500"
print '.'
Scraper.kvrquery(query)
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=2000"
print '.'
Scraper.kvrquery(query)
query="http://www.kvraudio.com/q.php?search=1&pr[]=f&av[]=re&sh[]=s&ob[]=dan&lm[]=500&bl[]=t&start=2500"
print '.'
Scraper.kvrquery(query)
puts 'done.'
