require_relative 'rpn_run'
if ARGV.count == 1
  file = ARGV[0]
  c = RPN.new
  c.start file
end

if ARGV.count > 1
  File.open('myfile.out', 'w') { |file| file.truncate(0) }
  ARGV.each do |x|
    f1 = File.readlines(x)
    open('myfile.out', 'a') do |f|
      f1.each do |q|
        f.puts q
      end
    end
    file = 'myfile.out'
  end
end

if ARGV.count.zero?
  c = REPL.new
  c.calculations
end
