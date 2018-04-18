require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'repl_mode'
# Test REPL
class REPLTest < Minitest::Test
  def setup
    @repl = REPL.new
  end

  # Check verifies that there are no uninitialized variables being passed in
  # If there is no uninitialized variable, it returns true
  def test_check
    val = @repl.check("5 5 5 19 +".split)
    assert_equal val, true
  end

  # Check verifies that there are no uninitialized variables being passed in
  # If there is an uninitialized variable, it outputs an error message
  def test_check_fail
    assert_output("Line 1: Variable A is not initialized\n") { @repl.check("5 5 A +".split) }
  end

  # This test verifies that if the input is blank, an error message is presented
  def test_got_input_blank
    assert_output("") { @repl.got_input('') }
  end

  # This test verifies that inputting a single number results in that number being output
  def test_got_input_number
    assert_output("5\n") { @repl.got_input("5\n") }
  end

  # This test throws an error message if an illegal word is input
  def test_got_input_word
    assert_output("Line 1: Could not evaluate expression\n") { @repl.got_input("cat dog\n") }
  end

  # Prints the result of any operation
  def test_key_print
    assert_output("234\n") { @repl.key_print("117 117 +".split)}
  end

  # Sets a variable to a number and then outputs that number
  def test_key_let
    assert_output("11\n") { @repl.key_let("A 11".split) }
  end

  # Sets a variable to the result of a few operations and outputs it
  def test_key_let_long
    assert_output("25\n") { @repl.key_let("A 11 3 * 8 -".split) }
  end

  # Checks that the system quits if the input is QUIT
  def test_got_input_quit
    assert_raises(SystemExit) { @repl.got_input("QUIT") }
  end
end
