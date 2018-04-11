# Variable class for all the variables
class Variables
	attr_accessor :var, :value
def initialize name, coins
	@name = name
	@coins = coins
end
end