class REPL
  attr_accessor :variables
  attr_accessor :line

  def initialize
    @variables = []
    @line = 1
  end

def getType(token)
  if isKeyword token
    return "keyword"
  elsif number token
    return "number"
  elsif letter token
    if token.chomp.size == 1
    return "variable"
  else
    return "word"
  end
  elsif isOperator token
    return "operator"
  errorCode 5,nil
  end
end

 def keyword(token)
    if token.first.casecmp('print').zero?
      if token.count > 1
      print_line token
      else
        errorCode 5,nil
      end
    elsif token.first.casecmp('let').zero?
      if token.count > 2
      let_var token
      else
        errorCode 5,nil
      end
    elsif token.first.casecmp('quit').zero?
      quit 0
    end
  end

  # isKeyword returns true if token is PRINT, LET, or QUIT
  # returns false otherwise
 def isKeyword token
   return true if token.casecmp('print').zero?
   return true if token.casecmp('let').zero?
   return true if token.casecmp('quit').zero?
   false
 end

  def lateWord token
    if token.count <= 1
      return false
    end
    token[1,token.size-1].each do |x|
      if "word" == getType(x)
        return true
      elsif "keyword" == getType(x)
        return true
      end
    end
    return false
  end


  def calculations
    while true
      print '> '
      token = gets

      # Error if token only contains \n
      if token.size < 2
        errorCode 5,nil
      end


      tok_array = token.split
      if lateWord tok_array
        errorCode 5,nil
      elsif isKeyword tok_array.first
        keyword tok_array
      elsif tok_array.count == 1
        if letter token
          if token.size > 2
            errorCode 4,token
          elsif active token
            puts get_value token
          else
            errorCode 1,token
          end
        elsif number token
          puts token
        else
          errorCode 5,nil
        end
      end
      @line += 1
    end
  end

  def errorCode(var,problem)
    if var==1
      puts "Line #{@line}: Variable #{problem.chomp} is not initialized"
    elsif var==2
      puts "Line #{@line}: Operator #{problem} applied to empty stack"
    elsif var==3
      puts "Line #{@line}: #{problem} elements in stack after evaluation"
    elsif var==4
      puts "Line #{@line}: Unknown keyword #{problem}"
    else
      puts "Line #{@line}: Could not evaluate expression"
    end
  end

  def split_line(text, line)
    text[line]
  end

  def let_var(token)
    if !letter token[1]
      errorCode 5,nil
      return
    elsif token.count < 3
      errorCode 5,nil
      return
    else
      if letter token[2]
        if !active token[2]
          errorCode 1,token[2]
          return
        end
      end
      token[2] = math token if token.count > 3
      if !active token[1]
      variable = Variables.new token[1].downcase, token[2]
      @variables << variable
      else
        change_value token[1],token[2]
      end
      puts token[2]
    end
  end



  def print_line(token)
    puts math token if token.count > 3
    print_var token if token.count == 2
  end

  def print_var(token)
    if number token[1]
      puts token[1]
    elsif letter token[1]
      if active token[1]
        puts get_value token[1]
      else
        errorCode 1,token[1]
      end
    else
      if !isOperator token[1]
        errorCode 4,token[1]
      else
        errorCode 5,nil
      end
    end
  end

  # Checks to see that token is in variables
  def active(token)
    @variables.each{ |x| return true if x.var == token.downcase.chomp }
    false
  end
  def change_value(token,value)
    @variables.each {|x| x.value = value if x.var == token.downcase.chomp}
  end
  def get_value(token)
    @variables.each {|x| return x.value if x.var == token.downcase.chomp}
  end

  def math(token)
    var = token
    var[1] = (get_var var[1]).value unless letter var[1].nil?
    var[2] = (get_var var[2]).value unless letter var[2].nil?
    var[1] = var[1].to_i if (letter var[1]).nil?
    var[2] = var[2].to_i if (letter var[2]).nil?
    operator = var[3] if isOperator var[3]
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

  # Returns true if var is +, -, *, or /
  def isOperator(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end

  # Returns true if var is only composed of letters
  def letter(var)
    (var =~ /[[:alpha:]]/) !=nil
  end

  # Returns true if var is only composed of numbers
  def number(var)
    (var =~ /[[:digit:]]/) != nil
  end

  def quit code
    exit(code)
  end

end
