# REPL
class REPL
  attr_accessor :variables
  attr_accessor :line
  def initialize
    @variables = []
    @line = 0
  end

  def keyword(token)
    if token[0].casecmp('print').zero?
      key_print(token[1, token.size - 1])
    elsif token[0].casecmp('let').zero?
      key_let(token[1, token.size - 1])
    elsif token[0].casecmp('quit').zero?
      quit 0
    end
  end

  def key_print(token)
    puts Errorcode.error 5, @line, nil unless token.count > 0
    print_line token if token.count > 0 && all_active(token)
  end

  def key_let(token)
    puts Errorcode.error 5, @line, nil unless token.count > 1
    let_var token if token.count > 1 && all_active(token[1, token.size - 1])
  end

  def all_active(token)
    token.each do |x|
      if Token.letter? x
        unless active x
          puts Errorcode.error 1, @line, x
          return false
        end
      end
    end
    true
  end

  def calculations
    loop do
      @line += 1
      print '> '
      token = gets
      # Error if token only contains \n
      if token.size < 2
        puts Errorcode.error 5, @line, nil
        next
      end
      tok_array = token.split
      # Error if there is a word after the first token
      if Token.late? tok_array
        puts Errorcode.error 5, @line, nil
        next
      elsif Token.illegal? tok_array
        puts Errorcode.error 5, @line, nil
        next
      elsif Token.keyword? tok_array.first
        keyword tok_array
        elsif tok_array.count == 1
          type = Token.get_type(token)
          if type == 'variable'
              puts get_value token if active token
              puts Errorcode.error 1, @line, token unless active token
          elsif type == 'word'
            puts Errorcode.error 4, @line, token
          elsif type == 'number'
            puts token
          else
            puts Errorcode.error 5, @line, nil
          end
        else
          print_line tok_array
      end
    end
  end

  def let_var(token)
    puts Errorcode.error 5, @line, nil unless Token.letter? token[0]
    return unless Token.letter? token[0]
    puts Errorcode.error 5, @line, nil if token.count < 2
    return if token.count < 2
    if token.count == 2
      if Token.letter? token[1]
        if active token[1]
          token[1] = get_value token[1]
        else
          puts Errorcode.error 1, @line, token[1]
          return
        end
      end
    else
      token[1] = MathClass.math_calc(token[1, token.size - 1], @line)
      return nil if token[1].nil?
    end
    if !active token[0]
      variable = Variables.new token[0].downcase, token[1]
      @variables << variable
    else
      change_value token[0], token[1]
    end
    puts token[1]
  end

  def print_line(token)
    print_var token if token.count == 1
    result = MathClass.math_calc token, @line if token.count > 1
    puts result unless result.nil?
  end

  def print_var(token)
    if Token.number? token[0]
      puts token[0]
    elsif Token.letter? token[0]
      if active token[0]
        puts get_value token[0]
      else
        puts Errorcode.error(1, @line, token[0])
      end
    elsif !Token.operator? token[0]
      puts Errorcode.error(4, @line, token[0])
    else
      puts Errorcode.error(5, @line, nil)
    end
  end

  # Checks to see that token is in variables
  def active(token)
    @variables.each { |x| return true if x.var == token.downcase.chomp }
    false
  end

  def change_value(token, value)
    @variables.each { |x| x.value = value if x.var == token.downcase.chomp }
  end

  def get_value(token)
    @variables.each { |x| return x.value if x.var == token.downcase.chomp }
  end

  def quit(code)
    exit(code)
  end
end
