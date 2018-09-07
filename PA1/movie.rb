class Movie

  def initialize(movie_id)
    @movie_id = movie_id
    @users = Hash.new
    @popularity_score = 0
  end

  def popularity()
    if @popularity_score == 0
      total_score = 0.0
      @users.values.each do |score|
        total_score += score.to_f
      end
      @popularity_score = total_score/@users.length.to_f
    end
    return @popularity_score
  end

  attr_accessor :users
  attr_reader :movie_id
end
