require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'math'
require_relative 'stack'
require_relative 'token'
require_relative 'errorcodes'
# Test math
class MathTest < Minitest::Test
  # Tests that addition is functional
  def test_code_addition
    val = CALC.math('5 7 +'.split, 17)
    assert_equal 12, val
  end

  # Tests that trying to add too few operands results in an error
  def test_code_add_failure
    string = "Line 13: Operator + applied to empty stack\n"
    assert_output(string) { CALC.math('5 +'.split, 13) }
  end

  # Tests that having leftover operands results in an error
  def test_code_number_failure
    string = "Line 19: 3 elements in stack after evaluation\n"
    assert_output(string) { CALC.math('5 5 5'.split, 19) }
  end

  # Tests that subtraction works
  def test_code_subtraction
    val = CALC.math('99 40 -'.split, 5)
    assert_equal(59, val)
  end

  # Tests to see division is functional
  def test_code_division
    val = CALC.math('25 5 /'.split, 3)
    assert_equal 5, val
  end

  # Tests to see that division can return a 0 if operand 2 is smaller than operand 1
  def test_code_div_decimal
    val = CALC.math('5 12 /'.split, 17)
    assert_equal 0, val
  end

  # Tests to make sure multiplication works
  def test_code_multiplication
    val = CALC.math('5 7 *'.split, 1)
    assert_equal 35, val
  end
end
