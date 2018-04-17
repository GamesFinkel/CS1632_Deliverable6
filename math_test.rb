require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'math'
require_relative 'stack'
require_relative 'token'
require_relative 'errorcodes'
# Test math
class MathTest < Minitest::Test
  def test_code_addition
    val = CALC.math('5 7 +'.split, 17)
    assert_equal 12, val
  end

  def test_code_add_failure
    val = CALC.math('5 +'.split, 13)
    assert_nil val
    string = "Line 13: Operator + applied to empty stack\n"
    assert_output(string) { CALC.math('5 +'.split, 13) }
  end

  def test_code_number_failure
    val = CALC.math('5 5 5'.split, 19)
    assert_nil val
    string = "Line 19: 3 elements in stack after evaluation\n"
    assert_output(string) { CALC.math('5 5 5'.split, 19) }
  end

  def test_code_subtraction
    val = CALC.math('99 40 -'.split, 5)
    assert_equal(-59, val)
  end

  def test_code_division
    val = CALC.math('5 25 /'.split, 3)
    assert_equal 5, val
  end

  def test_code_div_decimal
    val = CALC.math('5 12 /'.split, 17)
    assert_equal 2, val
  end

  def test_code_multiplication
    val = CALC.math('5 7 *'.split, 1)
    assert_equal 35, val
  end
end
