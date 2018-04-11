require_relative 'rpn_run'
raise 'Enter either one (1) or zero (0) files' if ARGV.count >= 3
file = ' '
file = ARGV[0] if ARGV.count == 1
c = RPN.new 
c.start file
