module Enumerable
  def my_each
    arr = self
    index = 0
    while index <= arr.length - 1
      yield (arr[index])
      index += 1
    end
    arr
  end
end

puts '============== test 1: my_each =============='
puts ''
print 'my_each :'
puts " #{[1, 2, 3, 4].my_each { |x| print x, ' -- ' }} "
puts ''
print 'each    :'
puts " #{[1, 2, 3, 4].each { |x| print x, ' -- ' }} "
