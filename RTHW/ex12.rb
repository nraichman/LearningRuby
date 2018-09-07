print "How much do you want to give? "
money = gets.chomp.to_f
change = money/10
puts "Your change is $#{change}"
