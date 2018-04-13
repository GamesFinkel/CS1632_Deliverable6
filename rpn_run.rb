require_relative 'variables'
# RPN decoder class
class RPN
  attr_accessor :variables
  attr_accessor :repl_mode
  attr_accessor :line

  def initialize
    @variables = []
    @repl_mode = true
    @line = 0
  end

  def start(file)
    if file == ' '
      puts 'REPL mode'
      @repl_mode = true
      text = ' '
    else
      @repl_mode = false
      text = open_file file
    end
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
      raise "Keyword didn't start line #{@line}\n"
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
    token = split_line text, @line unless @repl_mode
    token = gets if @repl_mode
    while valid_token token
      token = split_line text, @line unless @repl_mode
      token = gets if @repl_mode
      end_line text.count unless @repl_mode
      @line += 1
    end
  end

  def end_line(count)
    quit if @line == count
  end

  def split_line(text, line)
    text[line]
  end

  def let_var(token)
    # var[0] = keyword
    # var[1] = variable
    # var[2] = value
    var = token.split(' ')
    raise "Variable not a letter" if (letter var[1]).nil?
    raise "Not an integer at line #{@line}" unless var[2].to_i.is_a? Integer
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
    x = get_var(var[1]) if var[1].to_i.is_a? Integer #&& unless letter var[1].nil?
    puts x.value unless x == false
  end

  def get_var(variable)
    @variables.each { |x| return x if x.var == variable.downcase }
   # raise "Variable not initialized at line #{@line}" unless @repl_mode
    puts "Variable not initialized at line #{@line}"
    false
  end

  def math(token)
    var = token.split(' ')
    var[1] = (get_var var[1]).value unless letter var[1].nil?
    var[2] = (get_var var[2]).value unless letter var[2].nil?
    var[1]= var[1].to_i if (letter var[1]).nil?
    var[2] = var[2].to_i if (letter var[2]).nil?
    operator = var[3] if is_operator var[3]
    return addition var if operator == ('+')
    return subtraction var if operator == ('-')
    return multiplication var if operator == ('*')
    return division var if operator == ('/')
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

  def is_operator(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end

  def quit
    exit
  end
end
