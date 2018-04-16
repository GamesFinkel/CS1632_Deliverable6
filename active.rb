# Check if variables are active
class Active
  # Checks to see that token is in variables
  def self.active(variables, token)
    variables.each { |x| return true if x.var == token.downcase.chomp }
    false
  end

  def self.change_value(variables, token, value)
    variables.each { |x| x.value = value if x.var == token.downcase.chomp }
    variables
  end

  def self.get_value(variables, token)
    variables.each { |x| return x.value if x.var == token.downcase.chomp }
  end

  def self.all_active(variables, line, token)
    token.each do |x|
      next unless Token.letter? x
      unless Active.active(variables, x)
        Errorcode.error 1, line, x
        return false
      end
    end
    true
  end

  def self.to_num(variables, token)
    num_arr = []
    token.each do |x|
      if Active.active(variables, x)
        num_arr << get_value(variables, x)
        next
      end
      num_arr << x
    end
    num_arr
  end
end
