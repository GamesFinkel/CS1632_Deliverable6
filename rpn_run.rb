require_relative 'variables'
require_relative 'repl_mode'
require_relative 'file_math'
require_relative 'checker'
# RPN decoder class
class RPN
  attr_accessor :variables
  attr_accessor :line

  def initialize
    @variables = []
    @line = 0
    @checker = Checker.new
    @math = FileMath.new
    @stack = LinkedList::Stack.new
  end

  def check_start(token)
    out = @checker.check_line token
    @checker.quit [1, "Line #{@line}:" << out] unless out == true
  end

  def keyword(token)
    first1 = token.split.first
    first = first1.upcase
    return @checker.error(4, @line, first1) unless @checker.keyword? first
    return print_line token if first.casecmp('print').zero?
    return check_var token if first.casecmp('let').zero?
    @checker.quit [0, ' '] if first.casecmp('quit').zero?
  end

  def calculations(file)
    text = @checker.open_file file
    token = split_line text
    @line += 1
    while @line <= text.count
      check_start token
      toke = keyword token unless @checker.integer? token.split.first
      @checker.quit toke if toke.is_a?(Array)
      token = split_line text
      @line += 1
    end
  end

  def split_line(text)
    token = text[@line]
    token = text[@line += 1] if /\S/ !~ token
    token
  end

  def check_var(token)
    var = token.split(' ')
    return @checker.error(1, @line, var[1]) unless @checker.letter var[1]
    value = var[2]
    value = math var.drop(1).join(' ') if var.count > 3
    return value if value.is_a?(Array)
    #@checker.integer? value
    value = (get_var value).value if @checker.letter value
    let_var(token, value)
  end

  def let_var(token, value)
    var = token.split(' ')
    return set_var(var[1], value) unless get_var(var[1]).is_a?(Array)
    init_var(var[1].downcase, value)
  end

  def set_var(var, val)
    @variables.each do |x|
      x.value = val if x.var == var.downcase
    end
    true
  end

  def init_var(var, val)
    variable = Variables.new var, val
    @variables << variable
    true
  end

  def print_line(token)
    var = token.split(' ')
    return @checker.error(5, @line, 'f') if var.count == 3
    return print_count_2 token if var.count == 2
    return print_math token if var.count > 3
    true
  end

  def print_count_2(token)
    var = token.split(' ')
    puts var[1] if @checker.integer? var[1]
    return print_var token unless @checker.integer? var[1]
    true
  end

  def print_math(token)
    val = math token
    return val if val.is_a?(Array)
    puts val
    true
  end

  def print_var(token)
    var = token.split(' ')
    puts var[2] unless var[2].nil?
    x = get_var(var[1]) if var[1].to_i.is_a? Integer
    return x if x.is_a?(Array)
    puts x.value unless x == false
  end

  def get_var(variable)
    @variables.each { |x| return x if x.var == variable.downcase }
    [1, "Line #{@line}: Variable #{variable} is not initialized"]
  end

  def math(token)
    token.split(' ').drop(1).each do |x|
      @stack << x.to_i if @checker.integer? x
      if @checker.operator?(x)
        return @checker.error(2, @line, x) if @stack.size < 2
        @stack << @math.do_math(@stack.pop, @stack.pop, x)
      end
      @stack << get_var(x.downcase).value if @checker.letter x
    end
    return @checker.error(3, @line, @stack.size) if @stack.size > 1
    @stack.pop
  end
end
