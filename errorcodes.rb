# Keep track of the error codes
class Errorcode
  def self.error(var, line, problem)
    puts "Line #{line}: Could not evaluate expression" if var == 5
    return nil if var == 5
    erc = new_error(var, problem)
    puts "Line #{line}: #{erc}"
    nil
  end

  def self.new_error(var, problem)
    if var == 1
      "Variable #{problem.chomp} is not initialized"
    elsif var == 2
      return "#{problem} applied to empty stack" if problem == 'LET'
      "Operator #{problem} applied to empty stack"
    elsif var == 3
      "#{problem} elements in stack after evaluation"
    elsif var == 4
      "Unknown keyword #{problem}"
    end
  end
end
