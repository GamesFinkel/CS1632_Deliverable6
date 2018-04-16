require_relative 'checker'
require_relative 'stack'
# Does math when not in REPL
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

  def operator?(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end
end
