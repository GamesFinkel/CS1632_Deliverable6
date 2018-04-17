require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'file_math'
require_relative 'rpn_run'
# THis is the class for testing the driver methods
class RPNRuntest < Minitest::Test
  def setup
    @math = FileMath.new
    @rpn = RPN.new
  end

  def test_print_1_var
  	val = @rpn.print_line "PRINT a 10"
  	assert_equal val, [5, "Line 0: Could not evaluate expression"]
  end

  def test_let_var_rpn
  	val = @rpn.check_var "LET a 30 30 +"
  	assert_equal val, true
  end

  def test_let_var_invalid_get
    @rpn.check_var "LET a 1 2"
    val = @rpn.get_var "a"
    assert_equal val, [1, "Line 0: Variable a is not initialized"]
  end

  #def test_let_var_invalid_rpn
  #	val = @rpn.let_var "LET a 30 30 40 +"
  #	assert_equal val, [3, "Line 0: Stack has 2 elements after evaluation"]
  #end

  def test_print_var
  out, err = capture_io do
  	@rpn.check_var "LET a 30"
    @rpn.print_line "PRINT a"
  end
  assert_match %r%30%, out
  end

  def test_print_int
  out, err = capture_io do
    @rpn.print_line "PRINT 30"
  end
  assert_match %r%30%, out
  end

  def test_print_int
  out, err = capture_io do
    @rpn.print_line "PRINT 30 30 +"
  end
  assert_match %r%60%, out
  end
end
