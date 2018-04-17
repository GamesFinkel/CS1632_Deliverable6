# Token types
class Token
  def self.get_type(token)
    return 'number' if number? token
    return 'keyword' if keyword? token
    if letter? token
      return 'variable' if token.chomp.size == 1
      return 'word'
    end
    return 'operator' if operator? token
    'illegal'
  end

  def self.number?(var)
    return true if var.is_a? Integer
    case var
    when /\A[-+]?\d+\z/
      return true
    end
    false
  end

  def self.keyword?(token)
    return true if token.casecmp('print').zero?
    return true if token.casecmp('let').zero?
    return true if token.casecmp('quit').zero?
    false
  end

  def self.letter?(var)
    return false if (var =~ /[[:alpha:]]/).nil?
    return false unless (var =~ /\d/).nil?
    true
  end

  def self.operator?(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end

  def self.illegal?(var)
    return true if var.size.zero?
    var.each do |x|
      return true if get_type(x) == 'illegal'
    end
    false
  end

  def self.late?(token)
    return false if token.count <= 1
    token[1, token.size - 1].each do |x|
      return true if get_type(x) == 'word'
      return true if get_type(x) == 'keyword'
    end
    false
  end
end
