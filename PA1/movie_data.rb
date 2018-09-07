require "./user.rb"
require "./movie.rb"
require "./file_reader.rb"
class MovieData

  # the constructor of the MovieData class accepts a single parameter, the file name of the main data file. It reads the file content in.
  def initialize(filename)
    @usermap, @moviemap = FileReader.read(filename)
  end

  # returns an integer from 1 to 5 to indicate the popularity of a certain movie.
  # In this algorithm we simply call an Movie#popularity() which in turn just parses the list of users that rated the movie and finds the average score.
  def popularity(movie_id)
    movie_id_symbol = movie_id.to_sym
    movie = @moviemap[movie_id_symbol]
    if movie != nil
      return movie.popularity()
    else
      return nil
    end
  end

  # this will generate a list of all movie_id’s ordered by decreasing popularity
  # This method will popularity method for all movies and sort them accor
  def popularity_list()
    movies = @moviemap.values
    movies.sort_by{|movie| movie.popularity}
    return movies
  end

  # generates a number between 0 and 1 indicating the similarity in movie (preferences between user1 and user2. 0 is no similarity.)
  # In this algorithm we consider the movies that both users rated by using set intersection. We find the distance between their ratings and tally it up.
  # Next, we consider the movies that only one of the users rated. We consider this to be the largest distance and therefore tally 4 points in difference for each of those movies.
  # Finally we divide the total difference score over the number of movies considered and then divide that number by four. This gives us an average score of difference between 0 and 1.
  # We then subtract the difference score from 1 to get the similarity score where 1 is most similar and 0 is completely different.
  def similarity(user1_id, user2_id)
    user1 = @usermap[user1_id.to_sym] # each user has a set of movie ids that they liked
    user2 = @usermap[user2_id.to_sym]
    if user1 === nil || user2 == nil
      return nil
    end
    intersection_set = user1.movies.keys & user2.movies.keys
    difference_set = user1.movies.keys - user2.movies.keys
    total_difference = 0.0;
    intersection_set.each do |common_movie|
      user1_score = user1.movies[common_movie] # each movie has a dictionary of users that liked it and can get the score for a user
      user2_score = user2.movies[common_movie]
      total_difference += (user1_score - user2_score).abs.to_f
    end
    total_difference += 4.0*difference_set.length

    return 1.0 - (total_difference/(intersection_set | difference_set).length)/4.0
  end

  # this return a list of the 10 users whose tastes are most similar to the tastes of user u
  # This algorithm parses through all users and keeps the 10 users whose similarity to user u is the greatest.
  # It does so by using a helper method fit_in_list which allows it to check whether an element could be added to the list of 10 greatest.
  def most_similar(user)
    similar_list = Hash.new
    @usermap.values.each do |other|
      if other.user_id != user.to_sym
        similarity_score = similarity(user, other.user_id)
        if similar_list.length < 10
          similar_list[other.user_id] = similarity_score
        else
          id_to_delete = fit_in_list(similarity_score, similar_list)
          if id_to_delete != nil
            similar_list.delete(id_to_delete)
            similar_list[other.user_id] = similarity_score
          end
        end
      end
    end
    return similar_list.sort_by{|key, value| value.to_f}.to_a
  end

  private
  # This helper method checks whether a given element is bigger than or equal to the smallest element in the given list. If it is, it returns smallest user's id so it could be removed.
    def fit_in_list(new_score, similar_list)
      similar_list = similar_list.sort_by{|key, value| value.to_f}
      if new_score >= similar_list[0][1]
        return similar_list[0][0]
      end
      return nil
    end
end
