require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'token'
# Test token
class TokenTest < Minitest::Test
  def test_number
    val = Token.number? 5
    assert_equal val, true
  end

  def test_number_false
    val = Token.number? 'dog'
    assert_equal val, false
  end

  def test_keyword_quit
    val = Token.keyword? 'QUIT'
    assert_equal val, true
  end

  def test_keyword_print
    val = Token.keyword? 'pRiNt'
    assert_equal val, true
  end

  def test_keyword_let
    val = Token.keyword? 'lEt'
    assert_equal val, true
  end

  def test_keyword_false
    val = Token.keyword? 'egg'
    assert_equal val, false
  end

  def test_get_type_number
    val = Token.get_type '5'
    assert_equal 'number', val
  end

  def test_get_type_keyword
    val = Token.get_type 'print'
    assert_equal 'keyword', val
  end

  def test_get_type_variable
    val = Token.get_type 't'
    assert_equal 'variable', val
  end

  def test_get_type_word
    val = Token.get_type 'dog'
    assert_equal 'word', val
  end

  def test_get_type_operator
    val = Token.get_type '+'
    assert_equal 'operator', val
  end

  def test_get_type_illegal
    val = Token.get_type '12help'
    assert_equal 'illegal', val
  end

  def test_illegal_tokarray
    val = Token.illegal? 'LET A 5 1re'.split
    assert_equal val, true
  end

  def test_legal_tokarray
    val = Token.illegal? 'LET A 5'.split
    assert_equal val, false
  end

  def test_late_key
    val = Token.late? 'LET A 5 LET'.split
    assert_equal val, true
  end

  def test_late_word
    val = Token.late? 'LET A 5 dog'.split
    assert_equal val, true
  end

  def test_late_false
    val = Token.late? 'LET A 88'.split
    assert_equal val, false
  end
end
