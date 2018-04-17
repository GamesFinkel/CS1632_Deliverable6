require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'checker'
require_relative 'rpn_run'
# THis is the class for testing the driver methods
class ErrorsTest < Minitest::Test
  def setup
    @rpn = RPN.new
  end

  def test_error_1
  	val = @rpn.print_line "PRINT q"
  	assert_equal val, [1,"Line 0: Variable q is not initialized"]
  end

  def test_error_2
    val = @rpn.print_line "LET 45 45 - -"
    assert_equal val, [2, "Line 0: Operator - applied to empty stack"]
  end

  def test_error_3
    val = @rpn.print_line "LET 45 45 50 50 50 - -"
    assert_equal val, [3, "Line 0: Stack has 3 elements after evaluation"]
  end

  def test_error_4
    val = @rpn.keyword "FOO"
    assert_equal val, [4, "Line 0: Unknown keyword FOO"]
  end

  def test_error_5
    val = @rpn.print_line "LET - -"
    assert_equal val, [5, "Line 0: Could not evaluate expression"]
  end
end