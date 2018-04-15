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
    return [4, "Line #{@line}: Unknown keyword #{token.split.first}"] unless @checker.keyword? first
    print_line token if first.casecmp('print').zero?
    let_var token if first.casecmp('let').zero?
    quit 0, ' ' if first.casecmp('quit').zero?
    true
  end

  def calculations(text)
    token = text[@line]
    @line += 1
    while @line <= text.count
      out = @checker.check_line token
      quit 1, out << " at line #{@line}" unless out == true
      first = token.split.first
      quitter = keyword token
      if(quitter != true)
        quit quitter[0], quitter[1].to_s
      end
      token = text[@line]
      @line += 1
    end
  end

  def let_var(token)
    var = token.split(' ')
    value = var[2]
    quit 1, "Line #{@line}: Variable #{var[1]} is not a letter" unless @checker.letter var[1].downcase
    value = math var.drop(2).join(' ') if var.count > 3
    variable = Variables.new var[1].downcase, value
    @variables << variable
  end

  def print_line(token)
    var = token.split(' ')
    quit 6, "Line #{line}: Incorrect number of arguments for print" if var.count == 3
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
      elsif @checker.operator?(x)
        operator = x
        quit 2, "Line #{@line}: Stack empty when try to apply operator #{x}" if stack.size < 2
        val = @math.addition stack.pop, stack.pop if operator == '+'
        val = @math.subtraction stack.pop, stack.pop if operator == '-'
        val = @math.multiplication stack.pop, stack.pop if operator == '*'
        val = @math.division stack.pop, stack.pop if operator == '/'
        stack << val
        quit 2, 'Line #{@line}: Stack empty when trying to apply operator #{x}' if val == "Stack is empty"
      elsif @checker.letter x
        stack << get_var(x.downcase).value
      end
      }
    quit 3, "Line #{@line}: Stack has #{stack.size} elements after evaluation" if stack.size > 1
    stack.pop
  end

  def quit(errcode, reason)
    puts reason
    exit(errcode)
  end
end
