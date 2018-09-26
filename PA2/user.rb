class User

    def initialize(user_id)
        @user_id = user_id
        @voting_map = {}
        @genre_score_vector = Array.new(19, 0.0)
        @genre_count_vector = Array.new(19, 0)
    end

    attr_reader :user_idr
    attr_reader :voting_map
    attr_reader :genre_score_vector

    def add_movie_rating(movie, rating)
        @voting_map[movie.movie_id.to_sym] = rating
        genres = movie.genre_vector.each_index.select{|i| movie.genre_vector[i] == 1}
        genres.each do |genre|
            @genre_score_vector[genre] += ((rating - @genre_score_vector[genre])/(@genre_count_vector[genre]+1))
            @genre_count_vector[genre] += 1
        end
    end
end