module Enumerable
    def my_each
      index = 0
      while index<=self.length-1
          yield (self[index])
          index +=1
      end
      return self
    end
  end
  
  puts '============== test 1: my_each =============='
  puts ''
  print 'my_each :'
  p [1, 2, 3, 4].my_each { |x| print x, ' -- '}
  print 'each    :'
  p [1, 2, 3, 4].each { |x| print x, ' -- '}
  