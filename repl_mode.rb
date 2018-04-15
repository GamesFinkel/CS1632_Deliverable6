class REPL
  attr_accessor :variables
  attr_accessor :line
  attr_accessor :stack
  def initialize
    @variables = []
    @line = 1
    @stack = LinkedList::Stack.new
  end

def getType(token)
  if number token
    return "number"
  elsif isKeyword token
    return "keyword"
  elsif letter token
    if token.chomp.size == 1
      return "variable"
    else
      return "word"
    end
  elsif isOperator token
    return "operator"
  else
    return "illegal"
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
      let_var token[1,token.size-1]
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

 def illegalToken token
   token.each do |x|
     if getType(x)=="illegal"
       return true
     end
   end
   return false
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
      else

        tok_array = token.split

        # Error if there is a word after the first token
        if lateWord tok_array
          errorCode 5,nil
        elsif illegalToken tok_array
          errorCode 5,nil
        elsif isKeyword tok_array.first
          keyword tok_array
        elsif tok_array.count == 1
          type = getType(token)
          if getType(token)=="variable"
            if active token
              puts get_value token
            else
              errorCode 1,token
            end
          elsif getType(token)=="word"
              errorCode 4,token
          elsif getType(token)=="number"
            puts token
          else
            errorCode 5,nil
          end
        end
      end
      @line += 1
    end
  end

  def errorCode(var,problem)
    if @stack.size!=0
      @stack = LinkedList::Stack.new
    end
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

  def let_var(token)
    if !letter token[0]
      errorCode 5,nil
      return
    elsif token.count < 2
      errorCode 5,nil
      return
    elsif token.count == 2
      if letter token[1]
        if !active token[1]
          errorCode 1,token[1]
          return
        else
          token[1] = get_value token[1]
        end
      end
    else
      token[1] = math token[1,token.size-1]
      return nil if token[1] == nil
    end
      if !active token[0]
      variable = Variables.new token[0].downcase, token[1]
      @variables << variable
      else
        change_value token[0],token[1]
      end
      puts token[1]
  end



  def print_line(token)
    print_var token if token.count == 2
    puts math token if token.count > 3
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
    val = 0
    token.each do |x|
      type = getType(x)
      if type == "number"
        @stack << x
      elsif type == "variable"
        if active x
          @stack << get_value(x)
        else
          errorCode 1,x
          return nil
        end
      elsif type == "operator"
        if @stack.size < 2
          errorCode 2,x
          return nil
        elsif x == "+"
          val = addition @stack.pop,@stack.pop
        elsif x == "-"
          val = subtraction @stack.pop,@stack.pop
        elsif x == "*"
          val = multiplication @stack.pop,@stack.pop
        elsif x == "/"
          val = division @stack.pop,@stack.pop
        end
        @stack << val
      end
    end
    val = @stack.pop
    if @stack.size != 0
      errorCode 3,@stack.size
      return nil
    end
    val
  end

  def addition(op1,op2)
    op1.to_i+op2.to_i
  end

  def subtraction(op1,op2)
    op1.to_i-op2.to_i
  end

  def division(op1,op2)
    op1.to_i/op2.to_i
  end

  def multiplication(op1,op2)
    op1.to_i*op2.to_i
  end


  # Returns true if var is +, -, *, or /
  def isOperator(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end

  # Returns true if var is only composed of letters
  def letter(var)
    return false if (var =~ /[[:alpha:]]/) == nil
    return false if (var =~ /\d/) != nil
    true
  end
  # Returns true if var is only composed of numbers
  def number(x)
    /\A[-+]?\d+\z/ === x.chomp
  end

  def quit(code)
    exit(code)
  end

end
