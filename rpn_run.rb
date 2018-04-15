require_relative 'variables'
require_relative 'repl_mode'
require_relative 'stack'
# RPN decoder class
class RPN
  attr_accessor :variables
  attr_accessor :line

  def initialize
    @variables = []
    @repl_mode = true
    @line = 0
  end

  def start(file)
    if file == ' '
      puts 'REPL mode'
      c = REPL.new
      c.calculations
    else
      @repl_mode = false
      text = open_file file
      calculations text
    end
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
      raise "Keyword didn't start line #{@line + 1}\n"
    end
    true
  end

  def open_file(file)
    text = []
    File.open(file, 'r') do |f|
      f.each_line do |line|
        text << line
      end
    end
    text
  end

  def calculations(text)
    token = split_line text, @line 
    @line += 1
    while true
      if stack_check token
        exit(3) 
      else
        valid_token token
      end
      token = split_line text, @line
      end_line text.count
      @line += 1
    end
  end

  def stack_check(token)
    var = token.split(' ')
    if var.count > 4
      puts "Line #{@line + 1}: #{var.count} elements in stack after evaluation"
      return true
    end
    false
  end

  def end_line(count)
    quit if @line == count
  end

  def split_line(text, line)
    text[line]
  end

  def let_var(token)
    puts 'let'
    var = token.split(' ')
    puts var[1]
    raise "Line #{@line + 1}: Variable not a letter" unless letter var[1]
    raise "Line #{@line + 1}: Not an integer" unless is_integer? var[2]
    variable = Variables.new var[1].downcase, var[2]
    @variables << variable
  end

  def letter(var)
    var == /[[:alpha:]]/
    return true unless var.nil?
    return false if var.nil?
  end

  def print_line(token)
    var = token.split(' ')
    puts if is_integer? var[1]
    puts "math: #{math token}" if var.count > 3
    if var.count == 2
       if is_integer? var[1]
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
      #puts x.var
      return x if x.var == variable.downcase }
    raise "Line #{@line}: Variable not initialized"
  end

  # change so that input does not contain keyword or variable
  def math(token)
    val = 0
    stack = LinkedList::Stack.new
    var = token.split(' ')
    var.each {|x| 
      # puts x
      if is_integer? x
        puts "#{x} is an integer on stack"
        stack << x.to_i
      elsif keyword? x
        puts "keyword"
      elsif operator?(x)
        puts "#{x} is an operator"
        operator = x
        raise "Error 2: Stack empty when try to apply operator #{x}" if stack.is_empty?
        val = addition stack.pop, stack.pop if operator == '+'
        val = subtraction stack.pop, stack.pop if operator == '-'
        val = multiplication stack.pop, stack.pop if operator == '*'
        val = division stack.pop, stack.pop if operator == '/'
      elsif letter x
        puts "letter #{x}"
        puts "#{get_var(x).value} value"
        stack << get_var(x.downcase).value
      end
      }
    raise "Error 3: Stack has #{stack.size} elements after evaluation" unless stack.is_empty?
    return val

    #var[1] = (get_var var[1]).value unless letter var[1].nil?
    #var[2] = (get_var var[2]).value unless letter var[2].nil?
    #var[1] = var[1].to_i if (letter var[1]).nil?
    #var[2] = var[2].to_i if (letter var[2]).nil?
    #operator = var[3] if operator? var[3]
  end

  def addition(operand1, operand2)
    puts "adding"
    puts operand1
    puts operand2
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

  def is_integer?(x)
    /\A[-+]?\d+\z/ === x
  end

  def keyword?(x)
    keywordlist = ['LET', 'PRINT', 'QUIT']
    keywordlist.include?(x)
  end

  def quit
    exit
  end
end
