require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'repl_mode'
# Test REPL
class REPLTest < Minitest::Test
  def setup
    @repl = REPL.new
  end

  def test_check
    val = @repl.check("5 5 5 19 +".split)
    assert_equal val, true
  end

  def test_check_fail
    assert_output("Line 1: Variable A is not initialized\n") { @repl.check("5 5 A +".split) }
  end

  def test_got_input_blank
    assert_output("Line 1: Could not evaluate expression\n") { @repl.got_input('') }
  end

  def test_got_input_number
    assert_output("5\n") { @repl.got_input("5\n") }
  end

  def test_got_input_word
    assert_output("Line 1: Could not evaluate expression\n") { @repl.got_input("cat dog\n") }
  end

  def test_key_print
    assert_output("234\n") { @repl.key_print("234".split)}
  end

  def test_key_let
    assert_output("11\n") { @repl.key_let("A 11".split) }
  end

  def test_key_let_long
    assert_output("25\n") { @repl.key_let("A 11 3 * 8 -".split) }
  end

  def test_got_input_quit
    assert_raises(SystemExit) { @repl.got_input("QUIT") }
  end
end
