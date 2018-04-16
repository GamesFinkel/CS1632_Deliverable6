require_relative 'checker'
require_relative 'stack'
class FileMath
  def initialize
    @checker = Checker.new
  end

  def addition(operand1, operand2)
    # puts operand1
    # puts operand2
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

  def do_math(operator, val1, val2)
    puts "math"
    puts operator
    val = addition val1, val2 if operator == '+'
    val = subtraction val1, val2 if operator == '-'
    val = multiplication val1, val2 if operator == '*'
    val = division val1, val2 if operator == '/'
  end
end