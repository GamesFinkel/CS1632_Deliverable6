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
    raise "Line #{@line + 1}: Variable not a letter" if (letter var[1]).nil?
    raise "Line #{@line + 1}: Not an integer" unless var[2].to_i.is_a? Integer
    variable = Variables.new var[1].downcase, var[2]
    @variables << variable
  end

  def letter(var)
    var == /[[:alpha:]]/
  end

  def print_line(token)
    var = token.split(' ')
    puts math token if var.count > 3
    print_var token if var.count == 2
  end

  def print_var(token)
    var = token.split(' ')
    puts var[2] unless var[2].nil?
    x = get_var(var[1]) if var[1].to_i.is_a? Integer
    puts x.value unless x == false
  end

  def get_var(variable)
    @variables.each { |x|
      puts x.var
      return x if x.var == variable.downcase }
    # raise "Line #{@line}: Variable not initialized"
  end

  def math(token)
    var = token.split(' ')
    var[1] = (get_var var[1]).value unless letter var[1].nil?
    var[2] = (get_var var[2]).value unless letter var[2].nil?
    var[1] = var[1].to_i if (letter var[1]).nil?
    var[2] = var[2].to_i if (letter var[2]).nil?
    operator = var[3] if operator? var[3]
    return addition var if operator == '+'
    return subtraction var if operator == '-'
    return multiplication var if operator == '*'
    return division var if operator == '/'
  end

  def addition(var)
    var[1].to_i + var[2].to_i
  end

  def subtraction(var)
    var[1].to_i - var[2].to_i
  end

  def multiplication(var)
    var[1].to_i * var[2].to_i
  end

  def division(var)
    var[1].to_i / var[2].to_i
  end

  def operator?(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end

  def quit
    exit
  end
end
