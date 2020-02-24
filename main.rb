# rubocop:disable Metrics/ModuleLength
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
    0.upto(arr.length - 1) do |ii|
      yield arr[ii], ii
    end
    arr
  end

  # my_select method definition
  def my_select
    return to_enum :my_select unless block_given?

    arr = self
    back = []
    arr.my_each { |x| back << x if yield x }
    back
  end

  def inc_on_true(cont, cond)
    cont += 1 if cond
    cont
  end

  def param_reg(par, arr_i, t_reg, t_patt, who)
    # who is false for my_all method call
    # who is true for my_none method call
    return [t_reg, t_patt] if par.nil?

    # puts "param : #{par}, arr_i : #{arr_i}, t_reg : #{t_reg}, t_patt : #{t_patt} who : #{who}"
    # puts "is regexp? : #{par.class == Regexp}, is class? : #{par.class == Class}, parameter? : #{par.class}"
    # puts "Conditions elements ( #{par.class != Regexp}, #{par.class != Class}, #{true} )"
    # puts "conditions(par.class != Regexp, par.class != Class, true) : #{conditions(par.class != Regexp, par.class != Class, true)}"
    if par.class == Regexp && (!par.match(arr_i).nil? ^ who)
      t_reg += 1

    elsif conditions(par.class != Regexp, par.class == Class, true)
     # print "Its a class: t_patt before : #{t_patt} --> "
      t_patt = inc_on_true(t_patt, arr_i.is_a?(Module.const_get(par.to_s)) ^ who) # when no match and who is true ==> accumulate
     # puts "t_patt after: #{t_patt}"

    elsif conditions(par.class != Regexp, par.class != Class, true)
     # print "no class, evaluate pattern : t_patt before : #{t_patt} -->"
      t_patt = inc_on_true(t_patt, (arr_i == par) ^ who) # when no match and who is true ==> accumulate as it was called by my_none
     # puts "t_patt after : #{t_patt}"
    end
    [t_reg, t_patt]
  end

  # my_all? method definition
  def my_all?(param = nil)
    arr = self
    any_h = { t_b_e: 0, t_e: 0, t_rxp: 0, t_p: 0, who: false }

    0.upto(arr.length - 1) do |i|
      if param.nil?
        if block_given?
          any_h[:t_b_e] += 1 if yield arr[i]
        elsif !arr[i].nil? && arr[i] != false
          any_h[:t_e] += 1
        end
      end
      any_h[:t_rxp], any_h[:t_p] = param_reg(param, arr[i], any_h[:t_rxp], any_h[:t_p], false)
    end
    any_element_true(arr.length, any_h[:t_b_e], any_h[:t_e], any_h[:t_rxp], any_h[:t_p])

    # if we reach this step and all elements are thruty, we exit true.
  end

  def no_block_count(element_check, block, arr_i, param)
# puts "Checking no_block. element_count : #{element_check}, no-block? : #{block}, arr_i : #{arr_i}, pram : #{param} }"
# puts "--> evaluation: #{(!arr_i.nil? || arr_i != false) && !block && param.nil?} "
    element_check += 1 if (!arr_i.nil? || arr_i != false) && !block && param.nil?
    element_check
  end

  # my_any? method definition
  def my_any?(param = nil)
    arr = self
    any_h = { true_block_elements: 0, true_elements: 0, t_rxp: 0, true_pattern: 0, who: false }

    0.upto(arr.length - 1) do |i|
      if block_given?
        any_h[:true_block_elements] += 1 if yield arr[i]
      end
      any_h[:t_rxp], any_h[:true_pattern] = param_reg(param, arr[i], any_h[:t_rxp], any_h[:true_pattern], false)
      any_h[:true_block_elements] = no_block_count(any_h[:true_block_elements], block_given?, arr[i], param)
    end
    any_h[:true_block_elements] >= 1 || any_h[:t_rxp] >= 1 || any_h[:true_pattern] >= 1
  end

  def any_element_true(len, fbe, fel, freg, fpa)
    # method used inside my_none
    fbe == len || fel == len || freg == len || fpa == len
  end

  # my_none? method definition
  def my_none?(param = nil)
    arr = self
    any_h = { f_b_e: 0, f_e: 0, f_rxp: 0, f_p: 0, who: true }

    0.upto(arr.length - 1) do |i|
      if param.nil?
        if block_given?
          any_h[:f_b_e] += 1 unless yield arr[i] # counts false block's element
        elsif arr[i].nil? || arr[i] == false
          any_h[:f_e] += 1 # counts false element
        end
      end
      any_h[:f_rxp], any_h[:f_p] = param_reg(param, arr[i], any_h[:f_rxp], any_h[:f_p], any_h[:who])
    end
    any_element_true(arr.length, any_h[:f_b_e], any_h[:f_e], any_h[:f_rxp], any_h[:f_p])
  end

  # my_map method definition (updated after point 10 of assigment)
  def my_map(*my_proc)
    caller = self
    return to_enum :my_map_proc unless block_given? || my_proc[0].class == Proc

    back = []
    caller.my_each do |value|
      if my_proc[0].is_a? Proc
        back.push my_proc[0].call value
      elsif block_given?
        back.push(yield value)
      end
    end
    back
  end

  # my_count method definition
  def my_count(param = '')
    caller = self
    back = 0
    caller.my_each do |value|
      if block_given?
        back += 1 if yield value
      elsif param != '' && !block_given?
        back += 1 if value == param
      else
        back += 1
      end
    end
    back
  end

  def conditions(con1, con2, con3)
    # puts "hey I am here, con1: #{con1}, con2: #{con2}, con3: #{con3}"
    con1 && con2 && con3
  end

  # my_inject method definition
  def my_inject(*param)
    caller = self
    i = 0
    total = []
    caller.my_each do |value|
      if conditions(i.zero?, !param.nil?, param[0].is_a?(Numeric))
        total[0] = param[0]
      elsif conditions(i.zero?, block_given?, value.is_a?(Numeric))
        total[0] = value - value
      elsif conditions(i.zero?, block_given?, !value.is_a?(Numeric))
        total[0] = value.clear
      end
      total[i + 1] = yield total[i], value
      i += 1
    end
    total[-1]
  end
end
# rubocop:enable Metrics/ModuleLength

def multiply_els(arr)
  arr.my_inject(1) { |product, x| x * product }
end

puts '============== Point 1: #my_each =============='
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

puts '============== Point 2: #my_each_with_index =============='
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

puts '============== Point 3: #my_select =============='
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

puts '==============  Point 4 #my_all =============='
# rubocop:disable Lint/AmbiguousBlockAssociation
# rubocop:disable Lint/ParenthesesAsGroupedExpression

puts 'my_all_full: Test 1'
print '%w[ant bear cat].all? { |word| word.length >= 3 }    #==>: '
p %w[ant bear cat].all? { |word| word.length >= 3 }

print '%w[ant bear cat].my_all? { |word| word.length >= 3 } #==>: '
p %w[ant bear cat].my_all? { |word| word.length >= 3 }
puts ''

puts 'my_all_full: Test 2'
print '%w[ant bear cat].all? { |word| word.length >= 4 }    #==>: '
p %w[ant bear cat].all? { |word| word.length >= 4 }

print '%w[ant bear cat].my_all? { |word| word.length >= 4 } #==>: '
p %w[ant bear cat].my_all? { |word| word.length >= 4 }
puts ''

puts 'my_all_full: Test 3'
print '%w[ant bear cat].all?(/t/)    #==>: '
p %w[ant bear cat].all?(/a/)
print '%w[ant bear cat].my_all?(/t/) #==>: '
p %w[ant bear cat].my_all?(/a/) { |word| word.length >= 4 }
puts ''

puts 'my_all_full: Test 4'
print '[1, "b", 3.14].all?(Numeric)     #==>: '
p [1, 'b', 3.14].all?(Numeric)
print '[1, "b", 3.14].my_all?(Numeric)  #==>: '
p [1, 'b', 3.14].my_all?(Numeric)
puts ''

puts 'my_all_full: Test 4.a'
print '[1, "b", 3.14].all?(1)     #==>: '
p [1, 'b', 3.14].all?(1)
print '[1, "b", 3.14].my_all?(1)  #==>: '
p [1, 'b', 3.14].my_all?(1)
puts ''

puts 'my_all_full: Test 5'
print '[nil, true, 99].all?        #==>: '
p [nil, true, 99].all?
print '[nil, true, 99].my_all?     #==>: '
p [nil, true, 99].my_all?
puts ''

puts 'my_all_full: Test 6'
print '[].all?        #==>: '
p [].all?
print '[].my_all?     #==>: '
p [].my_all?
puts ''

puts '==============  Point 5. #my_any =============='

puts 'my_any_full: Test 1'
print '%w[ant bear cat].any? { |word| word.length >= 3 }    #==>: '
p %w[ant bear cat].any? { |word| word.length >= 3 }
print '%w[ant bear cat].my_any? { |word| word.length >= 3 } #==>: '
p %w[ant bear cat].my_any? { |word| word.length >= 3 }
puts ''

puts 'my_any_full: Test 2'
print '%w[ant bear cat].any? { |word| word.length >= 4 }    #==>: '
p %w[ant bear cat].any? { |word| word.length >= 4 }
print '%w[ant bear cat].my_any? { |word| word.length >= 4 } #==>: '
p %w[ant bear cat].my_any? { |word| word.length >= 4 }
puts ''

puts 'my_any_full: Test 3'
print '%w[ant bear cat].any?(/b/)    #==>: '
p %w[ant bear cat].any?(/b/)
print '%w[ant bear cat].my_any?(/b/) #==>: '
p %w[ant bear cat].my_any?(/b/)
puts ''

puts 'my_any_full: Test 4'
print '[1, "b", 3.14].any?(Numeric)     #==>: '
p [1, 'b', 3.14].any?(Numeric)
print '[1, "b", 3.14].my_any?(Numeric)  #==>: '
p [1, 'b', 3.14].my_any?(Numeric)
puts ''

puts 'my_any_full: Test 4.b'
print '%w[hoho hi cat].any?(Integer)     #==>: '
p %w[hoho hi cat].any?(Integer)
print '%w[hoho hi cat].any?(Integer)  #==>: '
p %w[hoho hi cat].any?(Integer)
puts ''

puts 'my_any_full: Test 5'
print '[nil, true, 99].any?        #==>: '
p [nil, true, 99].any?
print '[nil, true, 99].my_any?     #==>: '
p [nil, true, 99].my_any?
puts ''

puts 'my_any_full: Test 6'
print '[].any?        #==>: '
p [].any?
print '[].my_any?     #==>: '
p [].my_any?
puts ''

puts '============== Point 6 - #my_none =============='

puts 'my_none: Test 1'
print '%w[ant bear cat].none?    { |word| word.length == 5 } #==>: '
p %w[ant bear cat].none? { |word| word.length == 5 }
puts ''

print '%w[ant bear cat].my_none? { |word| word.length == 5 } #==>: '
p %w[ant bear cat].my_none? { |word| word.length == 5 }
puts ''

puts 'my_none: Test 2'
print '%w[ant bear cat].none?    { |word| word.length >= 4 } #==>: '
p %w[ant bear cat].none? { |word| word.length >= 4 }
print '%w[ant bear cat].my_none? { |word| word.length >= 4 } #==>: '
p %w[ant bear cat].my_none? { |word| word.length >= 4 }
puts ''

puts 'my_none: Test 3'
print '%w[ant bear cat].none?(/d/)     #==>: '
p %w[ant bear cat].none?(/d/)
print '%w[ant bear cat].my_none?(/d/)  #==>: '
p %w[ant bear cat].my_none?(/d/)
puts ''

puts 'my_none: Test 3.b'
print '%w[ant bear cat].none?(5)     #==>: '
p %w[ant bear cat].none?(5)
print '%w[ant bear cat].my_none?(5)  #==>: '
p %w[ant bear cat].my_none?(5)
puts ''

puts 'my_none: Test 4'
print '[1, 3.14, 42].none?(Float)        #==>: '
p [1, 3.14, 42].none?(Float)
print '[1, 3.14, 42].my_none?(Float)     #==>: '
p [1, 3.14, 42].my_none?(Float)
puts ''

puts 'my_none: Test 4.a'
print '[1, 3, 42].none?(String)        #==>: '
p [1, 3, 42].none?(String)
print '[1, 3, 42].my_none?(String)     #==>: '
p [1, 3, 42].my_none?(String)
puts ''

puts 'my_none: Test 5'
print '[].none?        #==>: '
p [].none?
print '[].my_none?     #==>: '
p [].my_none?
puts ''

puts 'my_none: Test 6'
print '[nil].none?        #==>: '
p [nil].none?
print '[nil].my_none?     #==>: '
p [nil].my_none?
puts ''

puts 'my_none: Test 7'
print '[nil,false].none?        #==>: '
p [nil, false].none?
print '[nil,false].my_none?     #==>: '
p [nil, false].my_none?
puts ''

puts 'my_none: Test 8'
print '[nil,false,true].none?        #==>: '
p [nil, false, true].none?
print '[nil,false,true].my_none?     #==>: '
p [nil, false, true].my_none?
puts ''

puts '==============  Point 7 #my_count =============='
puts 'my_any_full: Test 1'
print '[1, 2, 3, 4].count    #==>: '
p [1, 2, 3, 4].count

print '[1, 2, 3, 4].my_count #==>: '
p [1, 2, 3, 4].my_count
puts ''

puts 'my_any_full: Test 2'
print '[1, 2, 3, 4].count(2)     #==>: '
p [1, 2, 3, 4].count(2)

print '[1, 2, 3, 4].my_count(2)  #==>: '
p [1, 2, 3, 4].my_count(2)
puts ''

puts 'my_any_full: Test 3'
print '[1, 2, 3, 4].count { |x| (x % 2).zero }    #==>: '
p [1, 2, 3, 4].count { |x| (x % 2).zero? }
print '[1, 2, 3, 4].my_count { |x| (x % 2).zero } #==>: '
p [1, 2, 3, 4].my_count { |x| (x % 2).zero? }
puts ''

puts '==============  Point 8 #my_map =============='

puts 'my_map: Test 1'
print '(1..4).map { |i| i * i }    #==>: '
p (1..4).map { |i| i * i }

print '(1..4).my_map { |i| i * i } #==>: '
p (1..4).my_map { |i| i * i }
puts ''

puts 'my_map: Test 2'
print '[4, 6, 7, 9].map { |x| x / 2 > 3  }    #==>: '
p [4, 6, 7, 9].map { |x| x / 2 > 3 }

print '[4, 6, 7, 9].my_map { |x| x / 2 > 3 } #==>: '
p [4, 6, 7, 9].my_map { |x| x / 2 > 3 }
puts ''

puts 'my_map: Test 3'
print '[4, 6, 7, 9].map    #==>: '
p [4, 6, 7, 9].map

print '[4, 6, 7, 9].my_map #==>: '
p [4, 6, 7, 9].my_map
puts ''

puts '==============  Point 9 #my_inject =============='
puts 'my_any_full: Test 1'
print 'p (5..10).inject { |sum, n| sum + n }    #==>: '
p (5..10).inject { |sum, n| sum + n }

print 'p (5..10).my_inject { |sum, n| sum + n } #==>: '
p (5..10).my_inject { |sum, n| sum + n }
puts ''

puts 'my_any_full: Test 2'
print 'p (5..10).inject(1) { |product, n| product * n }     #==>: '
p (5..10).inject(1) { |product, n| product * n }

print 'p (5..10).my_inject(1) { |product, n| product * n }  #==>: '
p (5..10).my_inject(1) { |product, n| product * n }
puts ''

puts 'my_any_full: Test 3'
print 'p %w{ cat sheep bear }.inject { |memo, word| memo.length > word.length ? memo : word }     #==>: '
p %w[cat sheep bear].inject { |memo, word| memo.length > word.length ? memo : word }
print 'p %w{ cat sheep bear }.my_inject { |memo, word| memo.length > word.length ? memo : word }  #==>: '
p %w[cat sheep bear].my_inject { |memo, word| memo.length > word.length ? memo : word }
puts ''

puts '==============  POINT 10 - #my_inject test - multiply_else =============='
puts 'mutilply_els using my_inject: Test 1'
print 'p multiply_els([2, 4, 5])  #==>: '
p multiply_els([2, 4, 5])
puts ''

puts '==============  POINT 11/12 - #my_map modified =============='

my_proc = proc { |arg1| arg1 / 2 > 3 }

puts 'my_map: Test using normal block'
print '[4, 6, 7.0, 9].my_map { |x| x / 2 > 3  }    #==>: '
p [4, 6, 7.0, 9].my_map { |x| x / 2.0 > 3.0 }
puts ''

puts 'my_map: Test using proc & block - Executing Proc as priority'
print '[4, 6, 7.0, 9].my_map_proc(my_proc) {|arg1| arg1 / 2.0 > 3.0 } #==>: '
p [4, 6, 7.0, 9].my_map(my_proc) { |arg1| arg1 / 2.0 > 3.0 }

# rubocop:enable Lint/AmbiguousBlockAssociation
# rubocop:enable Lint/ParenthesesAsGroupedExpression
