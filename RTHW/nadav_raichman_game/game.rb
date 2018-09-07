require "./components.rb"
puts "Welcome adventurer. What is your name?", ">"

name = $stdin.gets.chomp

game = Engine.new(name)

game.play()
