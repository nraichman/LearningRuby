filename = ARGV.first

txt = open(filename)

puts "Here's your file #{filename}:"
print txt.read

print "Choose a location to seek in the file: "
location = $stdin.gets.chomp.to_i
puts "The content of the file starting at location #{location} is: "
txt.seek(location)
print txt.read
