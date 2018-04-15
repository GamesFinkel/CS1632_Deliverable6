require_relative 'rpn_run'
file = ' '
file = ARGV[0] if ARGV.count == 1

if ARGV.count > 1
  File.open('myfile.out', 'w') { |file| file.truncate(0) }
  ARGV.each { |x|
  f1 = File.readlines(x)
  open('myfile.out', 'a') do |f|
    f1.each { |q|
      f.puts q
    }
  end
  }
  file = 'myfile.out'
end

c = RPN.new
c.start file
