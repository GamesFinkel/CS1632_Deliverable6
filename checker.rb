# Checks what type a token is
class Checker
  def integer?(integer)
    /\A[-+]?\d+\z/ === integer
  end

  def keyword?(word)
    keywordlist = %w[LET PRINT QUIT]
    keywordlist.include?(word)
  end

  def letter(var)
    var =~ /[[:alpha:]]/
    return true unless var.nil?
    return false if var.nil?
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
end
