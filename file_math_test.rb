require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'file_math'
require_relative 'rpn_run'
# THis is the class for testing the file math methods
class FileMathTest < Minitest::Test
  def setup
    @math = FileMath.new
    @rpn = RPN.new
  end

  # Testing addition, return sum
  def test_addition
  	val = @rpn.math "PRINT 45 45 +"
  	assert_equal val, 90
  end

  # Testing subtraction, return difference
  def test_subtraction
    val = @rpn.math "PRINT 45 45 -"
    assert_equal val, 0
  end

  # Testing division, return quotient
  def test_division
    val = @rpn.math "PRINT 100 50 /"
    assert_equal val, 2
  end

  # Testing multiplication, return product
  def test_multiplication
    val = @rpn.math "PRINT 10 50 *"
    assert_equal val, 500
  end

  # testing addition on a variable, return value
  def test_letter
    @rpn.check_var "LET a 30"
    val = @rpn.math "PRINT a 50 +"
    assert_equal val, 80
  end

  # Testing the wrong keyword and return an error
  def test_keyword
    val = @rpn.keyword 'tester'
    assert_equal val, [4, "Line 0: Unknown keyword tester"]
  end
end
