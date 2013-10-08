  require 'json/add/core'
  require 'json/pure'
  print 'Parsing'
  fa=[]
  Dir.glob('json/*.json').select {|f| fa.push f}
  pa={}
  x=0
  y=fa.length
  y-=1
  fa.sort
  while x <= y
    file=File.readlines(fa[x])
    pa=JSON.parse(file.join)
    print '.'
    x+=1
  end
  puts 'done.'