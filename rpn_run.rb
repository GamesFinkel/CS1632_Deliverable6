require_relative 'variables'
require_relative 'repl_mode'
require_relative 'stack'
require_relative 'checker'
# RPN decoder class
class RPN
  attr_accessor :variables
  attr_accessor :line

  def initialize
    @variables = []
    @line = 0
    @checker = Checker.new
  end

  def start(file)
    text = @checker.open_file file
    calculations text
  end

  def valid_token(token)
    return false unless keyword token
    true
  end

  def keyword(token)
    if token.split.first.casecmp('print').zero?
      print_line token
    elsif token.split.first.casecmp('let').zero?
      let_var token
    elsif token.split.first.casecmp('quit').zero?
      quit
    else
      raise "Line #{@line + 1}: Unknown keyword #{token.split.first}\n"
    end
    true
  end

  def calculations(text)
    token = split_line text, @line
    @line += 1
    while @line <= text.count
      valid_token token
      token = split_line text, @line
      @line += 1
    end
  end

  def split_line(text, line)
    text[line]
  end

  def let_var(token)
    var = token.split(' ')
    puts var[1]
    value = var[2]
    raise "Line #{@line + 1}: Variable #{var[1]} not a letter" unless @checker.letter var[1]
    raise "Line #{@line + 1}: #{var[2]} is not an integer" unless @checker.integer? var[2]
    value = math var.drop(2).join(' ') if var.count > 3
    variable = Variables.new var[1].downcase, value
    @variables << variable
  end

  def print_line(token)
    var = token.split(' ')
    puts if @checker.integer? var[1]
    puts "math: #{math token}" if var.count > 3
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
    raise "Line #{@line}: Variable #{variable} not initialized"
  end

  # change so that input does not contain keyword or variable
  def math(token)
    val = 0
    stack = LinkedList::Stack.new
    var = token.split(' ')
    var.each {|x| 
      if @checker.integer? x
        stack << x.to_i
      elsif @checker.keyword? x
        puts "keyword"
      elsif operator?(x)
        operator = x
        raise "Error 2: Stack empty when try to apply operator #{x}" if stack.empty?
        val = addition stack.pop, stack.pop if operator == '+'
        val = subtraction stack.pop, stack.pop if operator == '-'
        val = multiplication stack.pop, stack.pop if operator == '*'
        val = division stack.pop, stack.pop if operator == '/'
        raise 'Error 2 at line #{@line + 1}: Stack empty when trying to apply operator #{x}' if val == "Stack is empty"
      elsif @checker.letter x
        stack << get_var(x.downcase).value
      end
      }
    raise 'Error 3: Stack has #{stack.size} elements after evaluation' unless stack.empty?
    val
  end

  def addition(operand1, operand2)
    # puts operand1
    # puts operand2
    operand1.to_i + operand2.to_i
  end

  def subtraction(operand1, operand2)
    operand1 - operand2
  end

  def multiplication(operand1, operand2)
    operand1 * operand2
  end

  def division(operand1, operand2)
    operand1 / operand2
  end

  def operator?(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end

  def quit
    exit
  end
end
