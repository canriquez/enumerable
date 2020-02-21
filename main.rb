module Enumerable
  # My each method definition

  def my_each
    return to_enum :my_each unless block_given?

    arr = self
    if arr.is_a? Array
      0.upto(arr.length - 1) do |index|
        yield (arr[index])
      end
    elsif arr.is_a? Range
      arr.step(1) do |value|
        yield value
      end
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

  def param_reg(par, arr_i, t_reg, t_patt, who)
    # who is false for my_all method call
    # who is true for my_none method call
    return [t_reg, t_patt] unless par != ''

    if par.class == Regexp && (!par.match(arr_i).nil? ^ who)
      t_reg += 1
    elsif par.class != Regexp && arr_i.is_a?(Module.const_get(par.to_s))
      t_patt += 1
    end
    [t_reg, t_patt]
  end

  # my_all? method definition
  def my_all?(param = '')
    arr = self
    true_block_elements = 0
    true_elements = 0
    true_regexp = 0
    true_pattern = 0

    0.upto(arr.length - 1) do |i|
      if param == ''
        if block_given?
          true_block_elements += 1 if yield arr[i]
        elsif !arr[i].nil? && arr[i] != false
          true_elements += 1
        end
      end
      true_regexp, true_pattern = param_reg(param, arr[i], true_regexp, true_pattern, false)
    end
    any_element_true(arr.length, true_block_elements, true_elements, true_regexp, true_pattern)

    # if we reach this step and all elements are thruty, we exit true.
  end

  def no_block_count(element_check, block, arr_i)
    element_check += 1 if (!arr_i.nil? || arr_i != false) && !block
    element_check
  end

  # my_any? method definition
  def my_any?(param = String)
    arr = self
    any_h = { true_block_elements: 0, true_elements: 0, t_rxp: 0, true_pattern: 0, who: false }

    0.upto(arr.length - 1) do |i|
      if block_given?
        any_h[:true_block_elements] += 1 if yield arr[i]
      end
      any_h[:true_block_elements] = no_block_count(any_h[:true_block_elements], block_given?, arr[i])
      any_h[:t_rxp], any_h[:true_pattern] = param_reg(param, arr[i], any_h[:t_rxp], any_h[:true_pattern], false)
      # return true if (!arr[i].nil? || arr[i] != false) && !block_given?
      # puts "matrix #{any_h}"
    end
    any_h[:true_block_elements] >= 1 || any_h[:t_rxp] >= 1 || any_h[:true_pattern] >= 1
  end

  def any_element_true(arrlen, fbe, fel, freg, fpa)
    # method used inside my_none
    a = fbe == arrlen || fel == arrlen
    b = freg == arrlen || fpa == arrlen
    a || b
  end

  # my_none? method definition
  def my_none?(param = '')
    arr = self
    flase_block_elements = 0
    false_elements = 0
    false_regexp = 0
    false_pattern = 0

    0.upto(arr.length - 1) do |i|
      if param == ''
        if block_given?
          flase_block_elements += 1 unless yield arr[i]
        elsif arr[i].nil? || arr[i] == false
          false_elements += 1
        end
      end

      false_regexp, false_pattern = param_reg(param, arr[i], false_regexp, false_pattern, true)
    end
    any_element_true(arr.length, flase_block_elements, false_elements, false_regexp, false_pattern)
  end

  # my_map method definition
  def my_map
    caller = self
    return to_enum :my_map unless block_given?

    back = []
    caller.my_each do |value|
      back.push(yield value)
    end
    back
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
# rubocop:disable Lint/AmbiguousBlockAssociation
# rubocop:disable Lint/ParenthesesAsGroupedExpression
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

puts '==============  my_all_full =============='

puts 'my_all_full: Test 1'
print '%w[ant bear cat].all? { |word| word.length >= 3 }    #==>: '
p %w[ant bear cat].all? { |word| word.length >= 3 }

print '%w[ant bear cat].my_all? { |word| word.length >= 3 } #==>: '
p %w[ant bear cat].my_all? { |word| word.length >= 3 }

puts 'my_all_full: Test 2'
print '%w[ant bear cat].all? { |word| word.length >= 4 }    #==>: '
p %w[ant bear cat].all? { |word| word.length >= 4 }

print '%w[ant bear cat].my_all? { |word| word.length >= 4 } #==>: '
p %w[ant bear cat].my_all? { |word| word.length >= 4 }

puts 'my_all_full: Test 3'
print '%w[ant bear cat].all?(/t/)    #==>: '
p %w[ant bear cat].all?(/a/)
print '%w[ant bear cat].my_all?(/t/) #==>: '
p %w[ant bear cat].my_all?(/a/) { |word| word.length >= 4 }

puts 'my_all_full: Test 4'
print '[1, "b", 3.14].all?(Numeric)     #==>: '
p [1, 'b', 3.14].all?(Numeric)
print '[1, "b", 3.14].my_all?(Numeric)  #==>: '
p [1, 'b', 3.14].my_all?(Numeric)

puts 'my_all_full: Test 5'
print '[nil, true, 99].all?        #==>: '
p [nil, true, 99].all?
print '[nil, true, 99].my_all?     #==>: '
p [nil, true, 99].my_all?

puts 'my_all_full: Test 6'
print '[].all?        #==>: '
p [].all?
print '[].my_all?     #==>: '
p [].my_all?

puts '==============  my_any_full =============='

puts 'my_any_full: Test 1'
print '%w[ant bear cat].any? { |word| word.length >= 3 }    #==>: '
p %w[ant bear cat].any? { |word| word.length >= 3 }

print '%w[ant bear cat].my_any? { |word| word.length >= 3 } #==>: '
p %w[ant bear cat].my_any? { |word| word.length >= 3 }

puts 'my_any_full: Test 2'
print '%w[ant bear cat].any? { |word| word.length >= 4 }    #==>: '
p %w[ant bear cat].any? { |word| word.length >= 4 }

print '%w[ant bear cat].my_any? { |word| word.length >= 4 } #==>: '
p %w[ant bear cat].my_any? { |word| word.length >= 4 }

puts 'my_any_full: Test 3'
print '%w[ant bear cat].any?(/b/)    #==>: '
p %w[ant bear cat].any?(/b/)
print '%w[ant bear cat].my_any?(/b/) #==>: '
p %w[ant bear cat].my_any?(/b/)

puts 'my_any_full: Test 4'
print '[1, "b", 3.14].any?(Numeric)     #==>: '
p [1, 'b', 3.14].any?(Numeric)
print '[1, "b", 3.14].my_any?(Numeric)  #==>: '
p [1, 'b', 3.14].my_any?(Numeric)

puts 'my_any_full: Test 5'
print '[nil, true, 99].any?        #==>: '
p [nil, true, 99].any?
print '[nil, true, 99].my_any?     #==>: '
p [nil, true, 99].my_any?

puts 'my_any_full: Test 6'
print '[].any?        #==>: '
p [].any?
print '[].my_any?     #==>: '
p [].my_any?

puts '==============  my_map =============='

puts 'my_map: Test 1'
print '(1..4).map { |i| i * i }    #==>: '
p (1..4).map { |i| i * i }

print '(1..4).my_map { |i| i * i } #==>: '
p (1..4).my_map { |i| i * i }

puts 'my_map: Test 2'
print '[4, 6, 7, 9].map { |x| x / 2 > 3  }    #==>: '
p [4, 6, 7, 9].map { |x| x / 2 > 3 }

print '[4, 6, 7, 9].my_map { |x| x / 2 > 3 } #==>: '
p [4, 6, 7, 9].my_map { |x| x / 2 > 3 }

puts 'my_map: Test 3'
print '[4, 6, 7, 9].map    #==>: '
p [4, 6, 7, 9].map

print '[4, 6, 7, 9].my_map #==>: '
p [4, 6, 7, 9].my_map

# rubocop:enable Lint/AmbiguousBlockAssociation
# rubocop:enable Lint/ParenthesesAsGroupedExpression
