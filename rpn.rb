# RPN decoder class
class RPN
  raise 'Enter either one (1) or zero (0) files' unless ARGV.count >= 2
  file = ARGV[0] if ARGV.count == 1
  token = gets
  text = open_file file
  while(valid_token token){

  }

  # Tokens shall be numbers, variable names, operators, or one of the keywords QUIT, LET, or PRINT.
  def valid_token(token)
    return true if token is_a? Integer
    return true if token is_a?
    return true 
  end
  
  def open_file file
    text = []
    File.open(file, "r") do |f|
      f.each_line do |line|
        text << line
        puts line
      end
    end
    return text
  end
end
