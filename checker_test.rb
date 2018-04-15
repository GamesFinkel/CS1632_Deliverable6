require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'checker'
# THis is the class for testing the driver methods
class CheckTest < Minitest::Test
  def setup
    @checker = Checker.new
  end

  def test_valid_line
  	val = @checker.check_line "LET A 45 45 +"
  	assert_equal val, true
  end

  def test_invalid_keyword
  	val = @checker.check_line "PRINT A 45 PRINT 45 +"
  	assert_equal val, false
  end

  def test_invalid_line
  	val = @checker.check_line "PRINT A 45 % 45 +"
  	assert_equal val, "Incorrect input %"
  end

  def test_open_file
  	File.open('tester.out', 'w') { |file| file.write("tester") }
  	val = @checker.open_file 'tester.out'
  	assert_equal val, ["tester"]
  end
end