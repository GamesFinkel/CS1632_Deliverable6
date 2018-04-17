require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'errorcodes'
# Test errorcodes
class ErrorcodeTest < Minitest::Test
  def test_code_5
    string = "Line 77: Could not evaluate expression\n"
    assert_output(string) { Errorcode.error(5, 77, nil) }
  end

  def test_code_4
    string = "Line 2: Unknown keyword dog\n"
    assert_output(string) { Errorcode.error(4, 2, 'dog') }
  end

  def test_code_3
    string = "Line 14: 31 elements in stack after evaluation\n"
    assert_output(string) { Errorcode.error(3, 14, 31) }
  end

  def test_code_2
    string = "Line 999: Operator + applied to empty stack\n"
    assert_output(string) { Errorcode.error(2, 999, '+') }
  end

  def test_code_1
    string = "Line 321: Variable x is not initialized\n"
    assert_output(string) { Errorcode.error(1, 321, 'x') }
  end

  def test_new_code_1
    string = Errorcode.new_error 1, 'R'
    assert_equal "Variable R is not initialized", string
  end
end
