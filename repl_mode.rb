# REPL
class REPL
  attr_accessor :vars
  attr_accessor :line
  def initialize
    @vars = []
    @line = 0
  end

  def keyword(token)
    key_print(token[1, token.size - 1]) if token.first.eql? 'print'
    key_let(token[1, token.size - 1]) if token[0].eql? 'let'
    quit 0 if token[0].eql? 'quit'
  end

  def check(token)
    Active.all_active(@vars, token)
  end

  def key_print(token)
    Errorcode.error 5, @line, nil unless token.count > 0
    print_line token if token.count > 0 && check(token)
  end

  def key_let(token)
    Errorcode.error 5, @line, nil unless token.count > 1
    let_var token if token.count > 1 && check(token[1, token.size - 1])
  end

  def calculations
    loop do
      @line += 1
      print '> '
      token = gets.downcase
      # Error if token only contains \n
      if token.size < 2
        Errorcode.error 5, @line, nil
        next
      end
      tok_array = token.split
      # Error if there is a word after the first token
      if Token.late? tok_array
        Errorcode.error 5, @line, nil
        next
      elsif Token.illegal? tok_array
        Errorcode.error 5, @line, nil
        next
      elsif Token.keyword? tok_array.first
        keyword tok_array
      elsif tok_array.count == 1
        type = Token.get_type(token)
        if type == 'variable'
          puts Active.get_value(@vars, token) if Active.active(@vars, token)
          Errorcode.error 1, @line, token unless Active.active(@vars, token)
        elsif type == 'word'
          Errorcode.error 4, @line, token
        elsif type == 'number'
          puts token
        else
          Errorcode.error 5, @line, nil
        end
      else
        print_line tok_array
      end
    end
  end

  def let_var(token)
    Errorcode.error 5, @line, nil unless Token.letter? token[0]
    return unless Token.letter? token[0]
    Errorcode.error 5, @line, nil if token.count < 2
    return if token.count < 2
    if token.count == 2
      token[1] = Active.get_value(@vars, token[1]) if Token.letter? token[1]
    else
      token[1] = CALC.math Active.to_num(@vars, token[1, token.size - 1]), @line
      return nil if token[1].nil?
    end
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
    token = CALC.math(Active.to_num(@vars, token), @line) if token.count > 1
    puts token unless token.nil?
  end

  def quit(code)
    exit(code)
  end
end
