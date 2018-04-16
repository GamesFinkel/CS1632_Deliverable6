class Checker
  def integer?(integer)
    /\A[-+]?\d+\z/ === integer
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
    alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
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
      if keyword? x
        return false
      end
      if(!letter(x) && !operator?(x) && !integer?(x))
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
    exit(0) if input == nil
    puts input[1]
    exit(input[2].to_i)
  end

  def error(errorcode, line, var)
  case errorcode
    when 1
      [1,"Line #{line}: Variable #{var} is not initialized"]
    when 2
      [2, "Line #{line}: Operator #{var} applied to empty stack"]
    when 3
      [3, "Line #{line}: Stack has #{var} elements after evaluation"]
    when 4
      [4, "Line #{line}: Unknown keyword #{var}"]
    when 5
      [5, "Line #{line}: Could not evaluate expression"]
    end
  end
end
