class Checker
  def integer?(integer)
    /\A[-+]?\d+\z/ === integer
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
      	return "Incorrect input #{x}"
      end
     end
     true
  end

  def operator?(var)
    ops = ['+', '-', '*', '/']
    ops.include?(var)
  end
end

