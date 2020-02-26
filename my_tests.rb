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

puts 'my_any_full: Test 5.a'
print '[nil, false, nil, false].any?        #==>: '
p [nil, false, nil, false].any?
print '[nil, false, nil, false].my_any?     #==>: '
p [nil, false, nil, false].my_any?
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

puts '==============  My Inject_proc =============='

print '[10, 20, 30, 40, 50].inject(:+) #==>: '
p [10, 20, 30, 40, 50].inject(:+)
print '[10, 20, 30, 40, 50].my_inject(:+) #==>: '
p [10, 20, 30, 40, 50].my_inject(:+)
puts ''

print '[1, 2, 3, 4, 5].inject(:*) #==>: '
p [1, 2, 3, 4, 5].inject(:*)
print '[1, 2, 3, 4, 5].my_inject(:*) #==>: '
p [1, 2, 3, 4, 5].my_inject(:*)
puts ''

print '[1, 2, 3, 4, 5].inject(:/) #==>: '
p [1, 2, 3, 4, 5].inject(:/)
print '[1, 2, 3, 4, 5].my_inject(:/) #==>: '
p [1, 2, 3, 4, 5].my_inject(:/)
puts ''

print '[10, 20, 30, 40, 50].inject(5,:+) #==>: '
p [10, 20, 30, 40, 50].inject(5, :+)
print '[10, 20, 30, 40, 50].my_inject(5,:+) #==>: '
p [10, 20, 30, 40, 50].my_inject(5, :+)
puts ''

print '[1, 2, 3, 4, 5].inject(5,:*) #==>: '
p [1, 2, 3, 4, 5].inject(5, :*)
print '[1, 2, 3, 4, 5].my_inject(5,:*) #==>: '
p [1, 2, 3, 4, 5].my_inject(5, :*)
puts ''

# rubocop:enable Lint/AmbiguousBlockAssociation
# rubocop:enable Lint/ParenthesesAsGroupedExpression