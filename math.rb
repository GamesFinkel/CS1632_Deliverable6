require_relative 'checker'
class Math
  def initialize
    @checker = Checker.new
  end

  def math_calc(token, line)
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
        raise 'Error 2 at line #{line + 1}: Stack empty when trying to apply operator #{x}' if val == "Stack is empty"
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
end