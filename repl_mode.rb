require_relative 'variables'
require_relative 'repl_mode'
require_relative 'stack'
require_relative 'errorcodes'
require_relative 'token'
require_relative 'math'
require_relative 'active'
# REPL
class REPL
  attr_accessor :vars
  attr_accessor :line
  def initialize
    @vars = []
    @line = 0
  end

  def keyword(token)
    key = token.first.downcase
    key_print(token[1, token.size - 1]) if key.eql? 'print'
    key_let(token[1, token.size - 1]) if key.eql? 'let'
    quit 0 if key.eql? 'quit'
  end

  def check(token)
    Active.all_active(@vars, @line, token)
  end

  def key_print(token)
    Errorcode.error 5, @line, nil unless token.count > 0
    print_line token if token.count > 0 && check(token)
  end

  def key_let(token)
    return Errorcode.error 5, @line, nil unless Token.letter?(token[0])
    return Errorcode.error 2, @line, 'LET' unless token.count > 1
    let_var token if check(token[1, token.size - 1])
  end

  def word?(token)
    token.each do |x|
      return x if Token.get_type(x) == 'word'
    end
    nil
  end

  def got_input(token)
    # Error if token only contains \n
    return Errorcode.error 5, @line, nil if token.size < 2
    tok_array = token.split
    # Error if there is a word after the first token
    return Errorcode.error 5, @line, nil if broken tok_array
    return keyword tok_array if Token.keyword? tok_array.first
    word = word?(tok_array)
    return Errorcode.error 4, @line, word unless word.nil?
    print_line tok_array if check tok_array
  end

  def broken(token)
    return false if token[0].casecmp('quit').zero?
    return true if Token.late? token
    return true if Token.illegal? token
    false
  end

  def calculations
    loop do
      @line += 1
      print '> '
      token = gets
      got_input token
    end
  end

  def let_var(token)
    token[1] = CALC.math Active.to_num(@vars, token[1, token.size - 1]), @line
    return nil if token[1].nil?
    if !Active.active(@vars, token[0])
      variable = Variables.new token[0].downcase, token[1].to_s
      @vars << variable
    else
      Active.change_value(@vars, token[0], token[1])
    end
    puts token[1]
  end

  def print_line(token)
    token = Active.to_num(@vars, token)
    token = CALC.math(token, @line) if token.count > 1
    puts token unless token.nil?
  end

  def quit(code)
    exit(code)
  end
end
