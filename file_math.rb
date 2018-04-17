require_relative 'checker'
require_relative 'stack'
# Class that contains the operations for math in RPN
class FileMath
  def initialize
    @checker = Checker.new
  end

  def addition(operand1, operand2)
    operand1.to_i + operand2.to_i
  end

  def subtraction(operand1, operand2)
    operand2 - operand1
  end

  def multiplication(operand1, operand2)
    operand1 * operand2
  end

  def division(operand1, operand2)
    operand2 / operand1
  end

  def do_math(op1, op2, operator)
    val = addition op1, op2 if operator == '+'
    val = subtraction op1, op2 if operator == '-'
    val = multiplication op1, op2 if operator == '*'
    val = division op1, op2 if operator == '/'
    val
  end
end
