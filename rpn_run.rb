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
    quit 4, "Line #{@line}: Unknown keyword #{token.split.first}" unless @checker.keyword? first
    print_line token if first.casecmp('print').zero?
    let_var token if first.casecmp('let').zero?
    quit if first.casecmp('quit').zero?
  end

  def calculations(text)
    token = split_line text, @line
    @line += 1
    while @line <= text.count
      first = token.split.first
      keyword token unless @checker.integer? first
      token = split_line text, @line
      @line += 1
    end
  end

  def split_line(text, line)
    text[line]
  end

  def let_var(token)
    var = token.split(' ')
    value = var[2]
    raise "Line #{@line}: Variable #{var[1]} is not a letter" unless @checker.letter var[1]
    value = math var.drop(2).join(' ') if var.count > 3
    variable = Variables.new var[1].downcase, value
    @variables << variable
  end

  def print_line(token)
    var = token.split(' ')
    if @checker.integer? var[1] && var.count == 2
       puts var[1]
    end
    puts "#{math token}" if var.count > 3
    if var.count == 2
       if @checker.integer? var[1]
         puts var[1] 
       else
         print_var token 
       end
    end
  end

  def print_var(token)
    var = token.split(' ')
    puts var[2] unless var[2].nil?
    x = get_var(var[1]) if var[1].to_i.is_a? Integer
    puts x.value unless x == false
  end

  def get_var(variable)
    @variables.each { |x| 
      return x if x.var == variable.downcase }
    quit 1, "Line #{@line}: Variable #{variable} is not initialized"
  end

  def math(token)
    val = 0
    stack = LinkedList::Stack.new
    var = token.split(' ')
    var.each {|x| 
      if @checker.integer? x
        stack << x.to_i
      elsif @checker.keyword? x
      elsif @math.operator?(x)
        operator = x
        raise "Error 2 at line #{@line}:: Stack empty when try to apply operator #{x}" if stack.size < 2
        val = @math.addition stack.pop, stack.pop if operator == '+'
        val = @math.subtraction stack.pop, stack.pop if operator == '-'
        val = @math.multiplication stack.pop, stack.pop if operator == '*'
        val = @math.division stack.pop, stack.pop if operator == '/'
        stack << val
        quit 2, 'line #{@line}: Stack empty when trying to apply operator #{x}' if val == "Stack is empty"
      elsif @checker.letter x
        stack << get_var(x.downcase).value
      end
      }
    quit 3, "at line #{@line}: Stack has #{stack.size} elements after evaluation" if stack.size > 1
    stack.pop
  end

  def quit(errcode, reason)
    puts reason
    exit(errcode)
  end
end
