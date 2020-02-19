module Enumerable
  # My each method definition

  def my_each
    return to_enum :my_each unless block_given?

    arr = self
    index = 0
    while index <= arr.length - 1
      yield (arr[index])
      index += 1
    end
    arr
  end

  # my_each_with_index method definition
  def my_each_with_index
    return to_enum :my_each unless block_given?

    arr = self
    index = 0
    while index <= arr.length - 1
      yield arr[index], index
      index += 1
    end
    arr
  end

  # my_select method definition
  def my_select
    return to_enum :my_each unless block_given?

    arr = self
    back = []
    index = 0
    while index <= arr.length - 1
      back << arr[index] if yield (arr[index])
      index += 1
    end
    back
  end

  # my_select method definition
  def my_all?
    arr = self
    nilfalse = true
    accum = 0

    0.upto(arr.length - 1) do |i|
      nilfalse = false unless arr[i].nil? || arr[i] == false
      # exits with nilfalse=true if any element is false or nil regardless if block is given or not
    end

    return false if (!block_given? && nilfalse) || nilfalse
    return true if !block_given? && !nilfalse

    # return false if nilfalse

    arr.my_each { |x| accum += 1 if yield x }
    accum == arr.length
  end
end

puts '============== test 1: my_each =============='
puts ''
print 'my_each :'
puts " #{[1, 2, 3, 4].my_each { |x| print x, ' -- ' }} "
puts ''
print 'each    :'
puts " #{[1, 2, 3, 4].each { |x| print x, ' -- ' }} "
puts ''
print 'my_each no-block: '
puts [1, 2, 3].my_each
puts ''
print 'each no-block   : '
puts [1, 2, 3].my_each
puts ''

puts '============== test 1: my_each_with_index =============='
puts ''
print 'my_each_with_index :'
puts " #{[5, 6, 7, 8].my_each_with_index { |x, y| print x * y }} "
puts ''
print 'each_with_index    :'
puts " #{[5, 6, 7, 8].each_with_index { |x, y| print x * y }} "
puts ''
print 'my_each_with_index no-block: '
puts [1, 2, 3].my_each_with_index
puts ''
print 'each_with_index no-block   : '
puts [1, 2, 3].my_each_with_index
puts ''

puts '============== test 1: my_select =============='
puts ''
print 'my_select :'
puts " #{[5, 6, 7, 8, 10, 11, 12].my_select { |x| (x + 1).even? }} "
puts ''
print 'select    :'
puts " #{[5, 6, 7, 8, 10, 11, 12].select { |x| (x + 1).even? }} "
puts ''
print 'my_select no-block: '
puts [1, 2, 3].my_select
puts ''
print 'select no-block   : '
puts [1, 2, 3].select
puts ''

puts '============== test 1: my_all =============='
puts ''
testarr = [2, 0, 99]
print "#{testarr}.my_all? { |x| x > 1 } :"
puts " #{testarr.my_all? { |x| x >= 1 }} "
puts ''
print "#{testarr}.all? { |x| x > 1 }   :"
puts " #{testarr.my_all? { |x| x >= 1 }} "
puts ''
print "#{testarr}.my_all? <no-block>: "
puts testarr.my_all?
puts ''
print "#{testarr}.all? <no-block>   : "
puts testarr.all?
puts ''
