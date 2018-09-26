require "./control.rb"

# ratings = Ratings.new("./ml-100k/u.data")
puts Control.run("./ml-100k/u.data", "./ml-100k/u2.test")
