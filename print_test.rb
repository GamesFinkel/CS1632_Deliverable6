require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require_relative 'checker'
require_relative 'rpn_run'
# THis is the class for testing the driver methods
class PrintTest < Minitest::Test
  def setup
    @rpn = RPN.new
  end

  def test_case_keyword_print
    val = @rpn.keyword "PrInT 30"
    assert_equal val, true
  end

  def test_case_keyword_let
    val = @rpn.keyword "lEt a 30 30 +"
    assert_equal val, true
  end
end
