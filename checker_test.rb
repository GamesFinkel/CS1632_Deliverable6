require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require 'rantly/minitest_extensions'
require_relative 'checker'
require_relative 'rpn_run'
require_relative 'variables'
# THis is the class for testing the driver methods
class CheckTest < Minitest::Test
  def setup
    @checker = Checker.new
    @rpn = RPN.new
  end

  # Testing line for correct tokens
  # returns true if line is valid
  def test_valid_line
  	val = @checker.check_line "LET A 45 45 +"
  	assert_equal val, true
  end

  # returns the string containing the incorrect token
  def test_invalid_line
    val = @checker.check_line "PRINT A 45 % 45 +"
    assert_equal val, " incorrect input %"
  end

  # Testing the bounds of the digits accepted
  # returns true if it accepts the value
   def test_get_upper_bound_value
    temp = Variables.new('c', '999999999999999999999999999')
    @rpn.variables << temp
    val = @rpn.get_var "c"
    assert_equal val.value, "999999999999999999999999999"
  end

  # returns the value of the middle bound zero
   def test_get_lower_bound_value
    @rpn.variables << Variables.new('d', '0')
    val = @rpn.get_var 'd'
    assert_equal val.value, "0"
  end

  # returns the value of the middle bound zero
  def test_decimal_value
    val = @checker.check_line('LET d 1.5')
    assert_equal val, " incorrect input 1.5"
  end

  def test_valid_keyword
    assert_equal (@checker.keyword? "LET"), true
  end

  def test_invalid_keyword
    assert_equal (@checker.keyword? "DOO"), false
  end

  def test_valid_letter
    assert_equal (@checker.letter "q"), true
  end

  def test_invalid_letter
    assert_equal (@checker.letter "1"), false
  end

  def test_invalid_keyword_position
  	val = @checker.check_line "PRINT A 45 PRINT 45 +"
  	assert_equal val, false
  end

  def test_invalid_character
  	val = @checker.check_line "PRINT A 45 % 45 +"
  	assert_equal val, " incorrect input %"
  end

  def test_open_file
  	File.open('tester.out', 'w') { |file| file.write("tester") }
  	val = @checker.open_file 'tester.out'
  	assert_equal val, ["tester"]
  end

  def test_num_always_integer
    property_of {
      variable = integer
      [variable]
    }.check { |variable|
      value = @checker.integer?(variable)
      assert value = true
    }
  end
end
