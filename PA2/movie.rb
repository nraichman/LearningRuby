class Movie

    def initialize(movie_id, name, genre)
        @movie_id = movie_id
        @name = name
        @genre_vector = genre
    end

    attr_reader :movie_id
    attr_reader :name
    attr_reader :genre_vector
end