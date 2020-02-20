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

  # my_all? method definition
  def my_all?
    arr = self
    accum = 0

    0.upto(arr.length - 1) do |i|
      return false if arr[i].nil? || arr[i] == false

      # exits if any element is false or nil regardless if block is given or not
      # we count truthy for element unless there is no block present
      if block_given?
        accum += 1 if yield arr[i]
      end
    end

    return true unless block_given?

    # we return true if no block present but we finish the first loop successfuly (so no nil or false)
    accum == arr.length
    # if we reach this step and all elements are thruty, we exit true.
  end

  # my_any? method definition
  def my_any?
    arr = self
    accum = 0

    0.upto(arr.length - 1) do |i|
      return true if (!arr[i].nil? || arr[i] != false) && !block_given?

      # exits with true if any element falsy and no block is present
      # we count truthy for element unless there is no block present
      if block_given?
        accum += 1 if yield arr[i]
      end
    end

    accum >= 1
    # we reach here only if: Or elements are thruthy with block present.
    # Or, there is no block and all elements are truthy
    # if we reach this step and at least one element is true, we exit true.
    # otherwise we will return false as there is no block condition met -
  end

  # my_none? method definition
  def my_none?(param = "")
    arr = self
    flase_block_elements = 0
    false_elements = 0
    false_regexp = 0
    false_pattern = 0

    0.upto(arr.length - 1) do |i|  
        if param == ""
          if block_given?
            flase_block_elements += 1 if !yield arr[i]
          else 
            false_elements += 1 if arr[i].nil? || arr[i] == false
          end
        elsif param.class == Regexp
            false_regexp += 1 if param.match(arr[i]).nil?
        else
            false_pattern += 1 if arr[i] === param
        end   
      end

      flase_block_elements == arr.length || false_elements == arr.length || false_regexp == arr.length || false_pattern == arr.length
      # if we reach this step and all elements are thruty, we exit true.

      # this code will return true if variable contains a pattern  !var.match(var.to_s).nil?
      # source: https://docs.ruby-lang.org/en/master/Regexp.html
      # other form: var.class == Regexp
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
testarr = [2, 10, 99]
print "#{testarr}.my_all? { |x| x > 1 } :"
puts " #{testarr.my_all? { |x| x >= 1 }} "
puts ''
print "#{testarr}.all? { |x| x > 1 }   :"
puts " #{testarr.all? { |x| x >= 1 }} "
puts ''
print "#{testarr}.my_all? <no-block>: "
puts testarr.my_all?
puts ''
print "#{testarr}.all? <no-block>   : "
puts testarr.all?
puts ''

puts '============== test 1: my_any =============='
puts ''
testarr = [2, 10, 51]
print "#{testarr}.my_any? { |x| x > 50 } :"
puts " #{testarr.my_any? { |x| x > 50 }} "
puts ''
print "#{testarr}.any? { |x| x > 50 }   :"
puts " #{testarr.any? { |x| x > 50 }} "
puts ''
print "#{testarr}.my_any? <no-block>: "
puts testarr.my_any?
puts ''
print "#{testarr}.any? <no-block>   : "
puts testarr.any?
puts ''

puts '==============  my_none =============='
puts 'my_none: Test 1'
print '%w[ant bear cat].none?    { |word| word.length == 5 } #==>: '
p %w[ant bear cat].none? { |word| word.length == 5 }

print '%w[ant bear cat].my_none? { |word| word.length == 5 } #==>: '
p %w[ant bear cat].my_none? { |word| word.length == 5 }

puts 'my_none: Test 2'
print '%w[ant bear cat].none?    { |word| word.length >= 4 } #==>: ' 
p %w[ant bear cat].none? { |word| word.length >= 4 }
print '%w[ant bear cat].my_none? { |word| word.length >= 4 } #==>: '
p %w[ant bear cat].my_none? { |word| word.length >= 4 }

puts 'my_none: Test 3'
print '%w[ant bear cat].none?(/d/)     #==>: '
p %w[ant bear cat].none?(/d/)
print '%w[ant bear cat].my_none?(/d/)  #==>: '
p %w[ant bear cat].my_none?(/d/)

puts 'my_none: Test 4'
print '[1, 3.14, 42].none?(Float)        #==>: '
p [1, 3.14, 42].none?(Float)
print '[1, 3.14, 42].my_none?(Float)     #==>: '
p [1, 3.14, 42].my_none?(Float)

puts 'my_none: Test 5'
print '[].none?        #==>: '
p [].none?
print '[].my_none?     #==>: '
p [].my_none?

puts 'my_none: Test 6'
print '[nil].none?        #==>: '
p [nil].none?
print '[nil].my_none?     #==>: '
p [nil].my_none?

puts 'my_none: Test 7'
print '[nil,false].none?        #==>: '
p [nil, false].none?
print '[nil,false].my_none?     #==>: '
p [nil, false].my_none?

puts 'my_none: Test 8'
print '[nil,false,true].none?        #==>: '
p [nil, false, true].none?
print '[nil,false,true].my_none?     #==>: '
p [nil, false, true].my_none?
