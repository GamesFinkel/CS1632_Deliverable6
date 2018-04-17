# Does all the math
class CALC
  @stack = nil
  def self.math(token, line)
    @stack = LinkedList::Stack.new
    token.each do |x|
      type = Token.get_type(x)
      val = type_action type, x, line
      return nil if val.nil?
      @stack << val
    end
    error 3, line, @stack.size if @stack.size > 1
    return @stack.pop if @stack.size == 1
    nil
  end

  def self.type_action(type, token, line)
    return token if type == 'number'
    if type == 'operator'
      return operation token unless @stack.size < 2
      error 2, line, token
    end
    nil
  end

  def self.error(number, line, problem)
    Errorcode.error number, line, problem
  end

  def self.operation(operator)
    return addition if operator == '+'
    return subtraction if operator == '-'
    return division if operator == '/'
    return multiplication if operator == '*'
  end

  def self.subtraction
    op1 = @stack.pop
    op2 = @stack.pop
    op2 - op1
  end

  def self.addition
    op1 = @stack.pop
    op2 = @stack.pop
    op2 + op1
  end

  def self.multiplication
    op1 = @stack.pop
    op2 = @stack.pop
    op2 * op1
  end

  def self.division
    op1 = @stack.pop
    op2 = @stack.pop
    op2 / op1
  end
end
