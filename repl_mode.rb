class REPL
  attr_accessor :variables
  attr_accessor :line

  def initialize
    @variables = []
    @line = 1
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

  def calculations
  	print '> '
    token = gets
    while true
      if stack_check token
        puts "Line #{@line}: #{var.count} elements in stack after evaluation"
      else
      	print '> '
        valid_token token
      end
      token = gets
      @line += 1
    end
  end

  def stack_check(token)
    var = token.split(' ')
    if var.count > 4
      return true
    end
    false
  end

  def split_line(text, line)
    text[line]
  end

  def let_var(token)
    var = token.split(' ')
    raise "Line #{@line}: Variable not a letter" if (letter var[1]).nil?
    raise "Line #{@line}: Not an integer" unless var[2].to_i.is_a? Integer
    var[2] = math token if var.count > 3
    variable = Variables.new var[1].downcase, var[2]
    @variables << variable
    puts var[2]
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
    @variables.each { |x| return x if x.var == variable.downcase }
    puts "Line #{@line}: Variable not initialized" 
    false
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