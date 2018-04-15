require_relative 'rpn_run'
raise 'Enter either one (1) or zero (0) files' if ARGV.count >= 3
file = ' '
file = ARGV[0] if ARGV.count == 1
if ARGV.count > 1
  File.open('myfile.out', 'w') {|file| file.truncate(0) }
  ARGV.each { |x|
  f1 = File.readlines(x)
  open('myfile.out', 'a') do |f|
    f1.each { |q|
      f.puts q
    }
  end
  }
  file = "myfile.out"
end
c = RPN.new 
c.start file
