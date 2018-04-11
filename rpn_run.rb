require_relative 'variables'
# RPN decoder class
class RPN

  attr_accessor :variables

  def initialize
    @variables = []
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
    return false unless keyword token, false
    return true
  end
  
  def keyword token, test
    first = token.split.first
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
    print "Invalid token at line #{count}\n"
  end

  def split_line(text, line)
    new_line = text[line]
  end

  def let_var(token)
    # var[0] = keyword
    # var[1] = variable
    # var[2] = value
    var = token.split(" ")
    #return false unless letter var[1]
    #return false unless var[2].is_a? Integer
    variable = Variables.new var[1].downcase, var[2] 
    @variables << variable
  end

  def letter(var)
    var =~ /[[:alpha:]]/
  end

  def print_var(token)
    var = token.split(" ")
    raise "Too many arguments" if var.count >= 3
    raise "Not enough arguments" if var.count <= 2
    val = get_var(var[1])
    raise "Unable to print variable that does not exist" if val == false
    puts val unless val == false
  end

  def get_var variable
    @variables.each {|x| 
      return x.value if (x.var).casecmp(variable)
    }
    return false
  end

  def quit
    exit
  end
end