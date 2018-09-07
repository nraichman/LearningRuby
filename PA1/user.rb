class User

  def initialize(user_id)
    @user_id = user_id
    @movies = Hash.new
  end

  attr_accessor :movies
  attr_reader :user_id
end
