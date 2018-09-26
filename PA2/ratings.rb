require "./movie.rb"
require "./user.rb"
require 'matrix'

require 'rubygems'
require 'algorithms'
include Containers

class Ratings

    @@genre_data_file = "./ml-100k/u.genre"
    @@movie_data_file = "./ml-100k/u.item"
    # @@similarity_radius = 1

    def initialize(filename)
        @genre_map = read_movie_map
        @movie_map = read_movie_map
        @user_location_map = {}  
        @user_map =  read_user_map(filename)
        # @kd_tree = KDTree.new(@user_location_map) // an attempt to implement method 3
       
        # @proximity_map = build_proximity_map
        # @space_tree = build_space_tree // an attempt to implement method 2
    end

    attr_reader :genre_map
    attr_reader :movie_map
    attr_reader :user_map
    attr_reader :user_location_map
    # attr_reader :space_tree


    # def build_space_tree()
    #     space_tree = Array.new(6,nil)
    #     @user_map.each do |user_id, user_obj|
    #         location = user_obj.genre_score_vector.map{|score| (score).to_i}
    #         # p space_tree
    #         add_user_to_space_tree(user_id, location, space_tree)
    #         @user_location_map[user_id] = location
    #     end
    #     return space_tree
    # end




    #reads the u.genre and creates a hash from a genre's id to it's name
    def read_genre_map()
        genre_data = open(@@genre_data_file).read
        genre_map = {}
        genre_data.each_line do |line|
            if line.chomp != ""
                genre_name, genre_id = line.split("|")
                genre_map[genre_id.chomp] = genre_name
            end
        end
        return genre_map
    end

    #reads the u.item and buils a hash from movie id to a movie object containing the movies genre vector.
    def read_movie_map()
        movie_data = open(@@movie_data_file).read.scrub
        movie_map = {}
        movie_data.each_line do |line|
            if line.chomp != ""
                movie_id, movie_name, _, _, _, *genre_vector = line.split("|")
                genre_vector = genre_vector.map(&:to_i)
                movie_map[movie_id.to_sym] = Movie.new(movie_id, movie_name, genre_vector)
            end
        end
        return movie_map
    end
    #reads the base file and creates a hash from a user's id to an object that holds the user's genre vector
    def read_user_map(filename)
        user_data = open(filename).read
        user_map = {}
        user_data.each_line do |line|
            user_id, movie_id, rating, _ = line.split(' ')
            if user_map[user_id.to_sym] == nil
                user_map[user_id.to_sym] = User.new(user_id.to_sym)
            end
            user_map[user_id.to_sym].add_movie_rating(@movie_map[movie_id.to_sym], rating.to_f)
            @user_location_map[user_id.to_sym] = user_map[user_id.to_sym].genre_score_vector.map{|x| x.round.to_i}
        end
        return user_map
    end

    # def build_proximity_map()
    #     proximity_map = new_multi_dimensional_array(Array.new(19,6))
    #     @user_map.each do |user_id, user_obj|
    #         location = user_obj.genre_score_vector.map{|score| (score).to_i}
    #         set_point_in_space(location,proximity_map, user_id)
    #         @user_location_map[user_id] = location
    #     end
    #     return proximity_map
    # end
    

    #a recursive helper method to create a multi dimentsional array specified by a list where each element in the list is a dimension and the value is the length of that dimention
    def new_multi_dimensional_array(dimensions)
        array = []
        return new_mda(dimensions, array)
    end
    #the recursive part of the driver method above
    def new_mda(dimensions, array)
        if dimensions.any?
            return Array.new(dimensions[0], new_mda(dimensions.drop(1), array))
        else
            return 0.0
        end
    end
    #a recursive helper method for getting the value saved within the specified coordinates specified by an array
    def get_point_in_space(point, space)
        if point.length > 1
            return access_point_in_space(point.drop(1), space[point.first])
        else
            return space[point.first]
        end
    end
    #a recursive helper method sets the value of a point in space 
    def set_point_in_space(point, space, value)
        if point.length > 1
            set_point_in_space(point.drop(1), space[point.first], value)
        else
            space[point.first] = value
        end
    end   

    # def get_subspace(point, radius, space)
    #     start = if point[0] >= radius then (point[0] - radius) else point[0] end
    #     finish = if (point[0] + radius + 1) <= space.length then point[0] + radius + 1 else space.length end
    #     if point.length > 1
    #         subspace = space.slice(start, finish)
    #         p point
    #         return subspace.map {|hyper_plane| get_subspace(point.drop(1), radius, hyper_plane)}
    #     else
    #         return space.slice(start, finish)
    #     end
    # end
    
    #trim all the nil buckets from a multidimensional array
    def find_elements_in_space(space)
        element_array = []
        space = space.flatten
        space.each {|bucket| element_array << bucket if bucket != nil}
        return element_array
    end
    #return the average popularity of the movie
    def movie_popularity(movie_id)
        sum = 0.0
        voters = 0.0
        @user_map.values.each do |user|
            rating = user.voting_map[movie_id]
            if rating != nil
                voters += 1
                sum += rating
            end
        end
        return sum/voters
    end

    # def predict(user_id, movie_id)
    #     user_location = @user_location_map[user_id]
    #     p user_location
    #     similarity_space = get_subspace(user_location, @@similarity_radius, @proximity_map)
    #     similar_users = find_elements_in_space(similarity_space)
    #     voters = 0.0
    #     sum = 0.0
    #     similar_users.each do |user|
    #         rating = user.voting_map[movie_id]
    #         if rating != nil
    #             voters += 1
    #             sum += rating
    #         end
    #     end
    #     if voters == 0.0
    #         return movie_popularity(movie_id)
    #     else
    #         return sum/voters
    #     end
    # end

    # def predict(user_id, movie_id)
    #     user = @user_map[user_id]
    #     location = user.genre_score_vector.map {|score| score.to_i}
    #     # p @space_tree
    #     sub_space = get_sub_tree(location, @space_tree)
    #     # sub_space = @space_tree
    #     # location.each do |score|
    #     #     sub_space = sub_space[score.to_i]
    #     # end
    #     p sub_space

    # end

    # def get_sub_tree(location, tree)
    #     if tree != nil
    #         start = if location[0] >= @@similarity_radius then (location[0] - @@similarity_radius) else location[0] end
    #         finish = if (location[0] + @@similarity_radius) <= tree.length then location[0] + @@similarity_radius else tree.length end
    #         if location.length > 1
    #             # p "start: #{start} ; finish: #{finish}"
    #             tree = tree.slice(start, finish).map {|sub_tree| get_sub_tree(location.drop(1), sub_tree)}
    #         else
    #             tree = tree.slice(start, finish)
    #         end
    #     end
    #     return tree
    # end

    def predict(user_id, movie_id)
        rating = @user_map[user_id.to_sym].voting_map[movie_id.to_sym]
        if rating == nil
            most_similar_list = get_most_similar_list(user_id)
            weighted_sum = 0.0
            weighted_total = 0.0
            rating = 0.0
            most_similar_list.each_pair do |other_id, similarity|
                user_obj = @user_map[other_id.to_sym]
                other_rating = user_obj.voting_map[movie_id.to_sym]
                weighted_sum += other_rating != nil ? other_rating*similarity : 0.0
                weighted_total += other_rating != nil ? similarity : 0.0
            end
            if weighted_sum == 0.0
                rating = find_movie_score_by_genre(movie_id.to_sym, most_similar_list)
            else
                rating = weighted_sum/weighted_total
            end
            return rating.round
        else
            return rating.to_i
        end
    end

    def find_cosine_similarity(vector1, vector2)
        vector1 = Vector.elements(vector1)
        vector2 = Vector.elements(vector2)
        dot_product = vector1.inner_product(vector2)
        return dot_product/(vector1.magnitude * vector2.magnitude)
    end

    def get_most_similar_list(user_id)
        user = @user_map[user_id.to_sym]
        score_vector = user.genre_score_vector
        most_similar_list = {}
        minimum = ""
        @user_location_map.each do |other_user_id, location|
            if  other_user_id != user_id   
                cosine_similarity = find_cosine_similarity(score_vector, location)
                # p cosine_similarity
                if most_similar_list.length < 10
                    most_similar_list[other_user_id] = cosine_similarity
                    if most_similar_list.length == 1
                        minimum = other_user_id
                    elsif cosine_similarity < most_similar_list[minimum]
                        minimum = other_user_id
                    end
                elsif cosine_similarity < most_similar_list[minimum]
                    most_similar_list.delete(minimum)
                    most_similar_list[other_user_id] = cosine_similarity
                    minimum = most_similar_list.min_by {|key, value| value}[0]
                end
            end
        end
        return most_similar_list.sort_by{|key, value| value}.to_h
    end

    def find_movie_score_by_genre(movie_id, most_similar_list)
        genre_sum = 0.0
        genre_total = 0.0
        genre_vector = @movie_map[movie_id].genre_vector
        movie_genre_vector = genre_vector.each_index.select {|i| genre_vector[i] == 1}
        most_similar_list.each_pair do |other_id, similarity|
            other_genre_vector = @user_location_map[other_id.to_sym]
            other_genre_sum = 0.0
            movie_genre_vector.each do |genre|
                other_genre_sum += other_genre_vector[genre]
            end
            genre_sum += (other_genre_sum/movie_genre_vector.length)*similarity
            genre_total += similarity
        end
        return  genre_sum/genre_total
    end

    
    def add_user_to_space_tree(user, location, space_tree)
        rating = location[0].to_i
        if  space_tree[rating] == nil
            space_tree[rating] = Array.new(6,nil)
        end
        
        if location.length > 1
            add_user_to_space_tree(user, location.drop(1),space_tree[rating])
        else
            space_tree[rating].append(user)
        end 
    end
        
end
