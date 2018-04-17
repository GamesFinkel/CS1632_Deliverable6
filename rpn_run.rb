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
  end

  def start(file)
    text = @checker.open_file file
    calculations text
  end

  def keyword(token)
    first = token.split.first
    return if @checker.integer? first
    return @checker.error(4, @line, first) unless @checker.keyword? first
    return print_line token if first.casecmp('print').zero?
    return let_var token if first.casecmp('let').zero?
    @checker.quit [0, ' '] if first.casecmp('quit').zero?
    true
  end

  def calculations(text)
    token = text[@line]
    @line += 1
    while @line <= text.count
      out = @checker.check_line token
      @checker.quit [1, "Line #{@line}:" << out] unless out == true
      toke = keyword token
      @checker.quit toke if toke.kind_of?(Array)
      token = text[@line]
      @line += 1
    end
  end

  def let_var(token)
    var = token.split(' ')
    value = var[2]
    return @checker.error(1, @line, var[1]) unless @checker.letter var[1]
    value = math var.drop(1).join(' ') if var.count > 3
    return value if value.kind_of?(Array)
    # return false unless @checker.decimal? value
    variable = Variables.new var[1].downcase, value
    @variables << variable
    true
  end

  def print_line(token)
    var = token.split(' ')
    return @checker.error(5, @line, 'f') if var.count == 3
    puts var[1] if (@checker.integer? var[1]) && (var.count == 2)
    return print_var token if (!@checker.integer? var[1]) && (var.count == 2)
    if var.count > 3
      val = math token
      return val if val.kind_of?(Array)
      puts val
    end
    true
  end

  def print_var(token)
    var = token.split(' ')
    puts var[2] unless var[2].nil?
    x = get_var(var[1]) if var[1].to_i.is_a? Integer
    return x if x.kind_of?(Array)
    puts x.value unless x == false
  end

  def get_var(variable)
    @variables.each { |x| return x if x.var == variable.downcase }
    return [1, "Line #{@line}: Variable #{variable} is not initialized"]
  end

  def math(token)
    stack = LinkedList::Stack.new
    var = token.split(' ')
    var.drop(1).each do |x|
      if @checker.integer? x
        stack << x.to_i
      elsif @checker.operator?(x)
        return @checker.error(2, @line, x) if stack.size < 2
        stack << @math.do_math(stack.pop, stack.pop, x)
      elsif @checker.letter x
        stack << get_var(x.downcase).value
      end
    end
    return @checker.error(3, @line, stack.size) if stack.size > 1
    stack.pop
  end
end
