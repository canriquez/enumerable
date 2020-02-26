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

    if par.class == Regexp && (!par.match(arr_i).nil? ^ who)
      t_reg += 1

    elsif conditions(par.class != Regexp, par.class == Class, true)
      t_patt = inc_on_true(t_patt, arr_i.is_a?(Module.const_get(par.to_s)) ^ who)

    elsif conditions(par.class != Regexp, par.class != Class, true)
      t_patt = inc_on_true(t_patt, (arr_i == par) ^ who)
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
    element_check += 1 if (!arr_i.nil? && arr_i != false) && !block && param.nil?
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

  def assign_if_true(total, value, eval1, eval2)
    if eval1 && eval2
      value
    else
      total
    end
  end

  def inject_total_param(total = [], param = [])
    if !param.nil? && param.my_any?(Symbol)
      total[0] = assign_if_true(total[0], 0, !param.my_any?(Numeric), param[0] == :+ || param[0] == :-)
      total[0] = assign_if_true(total[0], 1, !param.my_any?(Numeric), !(param[0] == :+ || param[0] == :-))
      total[0] = assign_if_true(total[0], param[0], param.my_any?(Numeric), true)
      param[0] = assign_if_true(param[0], param[1], param.my_any?(Numeric), true)
    end
    [total, param]
  end

  def zero_value_inject(total, iii, param, block, value)
    if conditions(iii.zero?, !param.nil?, param[0].is_a?(Numeric))
      total[0] = param[0]
    elsif conditions(iii.zero?, block, value.is_a?(Numeric))
      total[0] = value - value
    elsif conditions(iii.zero?, block, !value.is_a?(Numeric))
      total[0] = value.clear
    end
    total
  end

  # my_inject method definition
  def my_inject(*param)
    caller = self
    i = 0
    total = []
    caller.my_each do |value|
      total = zero_value_inject(total, i, param, block_given?, value)

      if !param.nil? && param.my_any?(Symbol)
        total, param = inject_total_param(total, param)
        total[i + 1] = total[i].send(param[0], value)
      else
        total[i + 1] = yield total[i], value
      end

      i += 1
    end
    total[-1]
  end
end
# rubocop:enable Metrics/ModuleLength

def multiply_els(arr)
  arr.my_inject(1) { |product, x| x * product }
end
