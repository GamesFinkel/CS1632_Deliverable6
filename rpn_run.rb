require_relative 'variables'
# RPN decoder class
class RPN

  attr_accessor :variables

  def initialize
    @variables = variables
  end

  def start file
    if(file == ' ')
      puts 'No file'
      file_input = false
      text = ' '
    else
      file_input = true
      text = open_file file 
      #puts text
    end
    calculations text, file_input
  end

  # Tokens shall be numbers, variable names, operators, or one of the keywords QUIT, LET, or PRINT.
  def valid_token(token)
    #val = keyword token, false
    return false unless keyword token, false
    return true if token.is_a? Integer
    #return true if token.is_a? String
    return true
  end
  
  def keyword token, test
    first = token.split.first
    puts token
    if(first.casecmp('print') == 0)
      return true if test
      print_var token
    elsif(first.casecmp('let') == 0)
      return true if test
      let_var token
    elsif(first.casecmp('quit') == 0)
      return true if test
      quit
    else
      return false
    end
    return true
  end

  def open_file file
    text = []
    File.open(file, "r") do |f|
      f.each_line do |line|
        text << line
      end
    end
    return text
  end

  def calculations(text, file_input)
    count = 0
    token = split_line text, count if file_input
    token = gets unless file_input
    while(valid_token token)
      token = split_line text, count if file_input
      token = gets unless file_input
      if(file_input)
        exit if count == text.count
      end
      count = count + 1     
    end
    print "Invalid token "
    print "at line #{count}\n" if file_input
  end

  def split_line(text, line)
    new_line = text[line]
  end

  def let_var(token)
  end

  def print_var(variable)
    puts variable
  end

  def get_var variable
    @variables.select { |list| list.var == variable }
  end

  def quit
    exit
  end
end