require_relative 'rpn_run'
if ARGV.count == 1
  file = ARGV[0]
  c = RPN.new
  c.start file
end

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

if ARGV.count == 0
   c = REPL.new
   c.calculations
end

