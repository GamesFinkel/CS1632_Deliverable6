require_relative 'variables'
# RPN decoder class
class RPN

  attr_accessor :variables
  attr_accessor :REPLmode
  attr_accessor :line

  def initialize
    @variables = []
    @REPLmode
    @line = 0 
  end

  def start file
    if(file == ' ')
      puts 'No file'
      @REPLmode = false
      text = ' '
    else
      @REPLmode = true
      text = open_file file 
      #puts text
    end
    calculations text
  end

  # Tokens shall be numbers, variable names, operators, or one of the keywords QUIT, LET, or PRINT.
  def valid_token(token)
    return false unless keyword token, false
    true
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
      false
    end
      true
  end

  def open_file(file)
    text = []
    File.open(file, "r") do |f|
      f.each_line do |line|
        text << line
      end
    end
    text
  end

  def calculations(text)
    token = split_line text, @line if @REPLmode
    token = gets unless @REPLmode
    while(valid_token token)
      token = split_line text, @line if @REPLmode
      token = gets unless @REPLmode
      if(@REPLmode)
        exit if @line == text.count
      end
      @line = @line + 1
    end
    print "Keyword didn't start line #{@line}\n"
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
    raise "Not an integer at line #{@line}" unless var[2].to_i.is_a? Integer
    variable = Variables.new var[1].downcase, var[2] 
    @variables << variable
  end

  def letter(var)
    var =~ /[[:alpha:]]/
  end

  def print_var(token)
    var = token.split(' ')
    x = get_var(var[1]) unless var[1].to_i.is_a? Integer
    puts x.value unless x == false
  end

  def get_var variable
    @variables.each | x |
      if x.var == variable.downcase
        return x
      end
    raise "Variable not initialized at line #{@line}" if @REPLmode
    puts "Variable not initialized at line #{@line}" 
    false
  end

  def quit
    exit
  end
end