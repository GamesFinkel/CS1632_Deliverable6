# Does all the math
class MathClass
  @stack = nil
  def self.math_calc(token, line)
    @stack = LinkedList::Stack.new
    token.each do |x|
      type = Token.get_type(x)
      val = type_action type, x, line
      return nil if val.nil?
      @stack << val
    end
    puts error 3, line, @stack.size if @stack.size > 1
    return @stack.pop if @stack.size == 1
    nil
  end

  def self.type_action(type, token, line)
    return token if type == 'number'
    elsif type == 'operator'
      return operation token unless @stack.size < 2
      puts error 2, line, x
    end
    nil
  end

  def self.error(number, line, problem)
    ErrorCode.error number, line, problem
  end

  def self.operation(operator)
    return addition if operator == '+'
    return subtraction if operator == '-'
    return division if operator == '/'
    return multiplication if operator == '*'
  end

  def self.addition
    @stack.pop + @stack.pop
  end

  def self.subtraction
    @stack.pop - @stack.pop
  end

  def self.multiplication
    @stack.pop * @stack.pop
  end

  def self.division
    @stack.pop / @stack.pop
  end
end
