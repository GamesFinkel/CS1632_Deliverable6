require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'errorcodes'
# Test errorcodes
class ErrorcodeTest < Minitest::Test
  # Makes sure that error code 5 returns a could not evaluate
  def test_code_5
    string = "Line 77: Could not evaluate expression\n"
    assert_output(string) { Errorcode.error(5, 77, nil) }
  end

  # Makes sure that error code 4 returns an unknown keyword
  def test_code_4
    string = "Line 2: Unknown keyword dog\n"
    assert_output(string) { Errorcode.error(4, 2, 'dog') }
  end

  # Makes sure that error code 3 returns elements in stack
  def test_code_3
    string = "Line 14: 31 elements in stack after evaluation\n"
    assert_output(string) { Errorcode.error(3, 14, 31) }
  end

  # Makes sure that error code 2 returns an operator error
  def test_code_2
    string = "Line 999: Operator + applied to empty stack\n"
    assert_output(string) { Errorcode.error(2, 999, '+') }
  end

  # Makes sure that error code 1 returns an initialization error
  def test_code_1
    string = "Line 321: Variable x is not initialized\n"
    assert_output(string) { Errorcode.error(1, 321, 'x') }
  end

  # Checks that new_error returns an error without a line number
  def test_new_code_1
    string = Errorcode.new_error 1, 'R'
    assert_equal "Variable R is not initialized", string
  end
end
