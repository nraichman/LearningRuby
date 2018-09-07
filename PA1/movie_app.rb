require "./movie_data.rb"
filename = ARGV.first
movie_database = MovieData.new(filename)

puts "Welcome to the movie data base app!"
while true
  puts "What would you like find out?"
  puts "\n1. Find out the popularity of a movie by its ID"
  puts "2. List movies by popularity"
  puts "3. Find out the similarity between two users"
  puts "4. Find out the most similar users to given user"
  puts "5. Quit"

  answer = $stdin.gets.chomp
  if answer == '1'
    puts "What is the ID of the movie?"
    answer = $stdin.gets.chomp
    popularity = movie_database.popularity(answer)
    if popularity == nil
      puts "The movie ID you chose doesn't exist in our database. Please try again."
    else
      puts "The average popularity of the movie with ID #{answer} is: #{popularity}"
    end

  elsif answer == '2'
    movie_list = movie_database.popularity_list
    puts "Here are the movies sorted by their popularity:\n"
    i = 1
    movie_list.each do |movie|
      puts "#{i}. #{movie.movie_id}"
      i += 1
    end
  elsif answer == '3'
    puts "Please enter two user IDs to compare seperated by a space"
    answer = $stdin.gets.chomp
    user1, user2 = answer.split(' ')
    if user1 == nil || user2 == nil
      puts "please enter two user IDs"
      next
    end
    similarity_score = movie_database.similarity(user1, user2)
    if similarity_score == nil
      puts "One of the user IDs you have entered does not exist in our database"
    else
      puts "The similarity score is: #{similarity_score}"
    end
  elsif answer == '4'
    puts "Please enter a user's ID"
    answer = $stdin.gets.chomp
    similarity_list = movie_database.most_similar(answer)
    if similarity_list == nil
      puts "The user ID you have entered does not exist in our database"
    else
      puts "The list of most similar users:"
      i = 1
      similarity_list.reverse.each do |user|
        puts "#{i}. ID: #{user[0]}  Similarity Score: #{user[1]}"
        i += 1
      end
    end
  elsif answer == '5'
    puts "Thank you for using our database! See you next time!"
    exit(0)
  else
    puts "Invalid input! Try again!"
  end
end
