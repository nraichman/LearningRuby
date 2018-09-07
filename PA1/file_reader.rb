require "./user.rb"
require "./movie.rb"
class FileReader

  def self.read(filename)
    data = open(filename).read
    user_map = Hash.new
    movie_map = Hash.new
    data.each_line do |line|
      user_id, movie_id, rating, timestamp = line.split(' ')
      movie = movie_map[movie_id.to_sym]
      if movie == nil
        movie = Movie.new(movie_id.to_sym)
        movie_map[movie_id.to_sym] = movie
      end
      #puts movie.users
      movie.users[user_id.to_sym] = rating.to_f
      #puts movie.users
      user = user_map[user_id.to_sym]
      if user == nil
        user = User.new(user_id.to_sym)
        user_map[user_id.to_sym] = user
      end
      user.movies[movie_id.to_sym] = rating.to_f
    end
    return user_map, movie_map
  end
end
