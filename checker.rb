# Checker class to check all the tokens in RPN
class Checker
  def integer?(integer)
    case integer
    when /\A[-+]?\d+\z/
      return true
    end
    false
  end

  def decimal?(integer)
    integer % 1 != 0
  end

  def keyword?(word)
    keywordlist = %w[LET PRINT QUIT]
    keywordlist.include?(word)
  end

  def letter(var)
    return false if var.length > 1
    alphabet = %w[a b c d e f g]
    alphabet2 = %w[h i j k l m]
    (alphabet << alphabet2).flatten!
    alphabet2 = %w[n o p q r s t]
    alphabet3 = %w[u v w x y z]
    (alphabet << alphabet2).flatten!
    (alphabet << alphabet3).flatten!
    alphabet.include?(var.downcase)
  end

  def open_file(file)
    text = []
    File.open(file, 'r') do |f|
      f.each_line do |line|
        text << line
      end
    end
    text
  end

  def check_line(token)
    var = token.split(' ')
    var.drop(1).each do |x|
      return false if keyword? x
      if !letter(x) && !operator?(x) && !integer?(x)
        return " incorrect input #{x}"
      end
    end
    true
  end

  def operator?(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end

  def quit(input)
    exit(0) if input.nil?
    puts input[1]
    exit(input[2].to_i)
  end

  def error(errorcode, line, var)
    return bigger_error errorcode, line, var if errorcode > 3
    case errorcode
    when 1
      [1, "Line #{line}: Variable #{var} is not initialized"]
    when 2
      [2, "Line #{line}: Operator #{var} applied to empty stack"]
    when 3
      [3, "Line #{line}: Stack has #{var} elements after evaluation"]
    end
  end

  def bigger_error(errorcode, line, var)
    case errorcode
    when 4
      [4, "Line #{line}: Unknown keyword #{var}"]
    when 5
      [5, "Line #{line}: Could not evaluate expression"]
    end
  end
end
