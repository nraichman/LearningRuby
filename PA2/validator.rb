require "./ratings.rb"
class Validator

    def initialize(base_file, test_file)
        @base_ratings = Ratings.new(base_file)
        @test_ratings = Ratings.new(test_file)
    end

    def validate()
        difference_list = []
        real_list = []
        predicted_list = []
        control_list = []
        total_checked = 0
        start_time = Time.now
        @test_ratings.user_map.each_pair do |user_id, user_obj|
            user_voting_map = user_obj.voting_map
            user_voting_map.each do |movie_id, rating|
                predicted_rating = @base_ratings.predict(user_id, movie_id)
                real_rating = @test_ratings.predict(user_id, movie_id)
                difference_list << real_rating - predicted_rating
                control_list << real_rating - 4.0
                real_list << real_rating
                predicted_list << predicted_rating
            end
            total_checked += 1
        end
        finish_time = Time.now
        exact_hits = difference_list.count(0)
        exact_hits_control = control_list.count(0)
        near_misses = difference_list.count{|x| x <= 1 && x > 0}
        near_misses_control = control_list.count{|x| x <= 1 && x > 0}
        mae = mae(difference_list)
        mae_control = mae(control_list)
        stdv = stdv(difference_list)
        stdv_control = stdv(control_list)
        mape = mape(real_list, predicted_list)
        mape_control = mape(real_list, Array.new(real_list.length, 4))
        accuracy = difference_list.inject {|sum, n| sum + n.abs}.to_f / Array.new(difference_list.length, 5).reduce(:+).to_f
        accuracy_control = control_list.inject {|sum, n| sum + n.abs}.to_f / Array.new(difference_list.length, 5).reduce(:+).to_f
        total_time = finish_time - start_time
        avg_time_per_predict = total_time / total_checked

        s = %Q/
               The statistics for this run were:
                
                Test:
                    Exact Hits:                  #{exact_hits}
                    Near Misses:                 #{near_misses}
                    Mean Absolute Error:         #{mae}
                    Standard Deviation:          #{stdv}
                    Mean Absolute Percent Error: #{mape*100.round(2)}%
                    Percent Accuracy:            #{(1-accuracy)*100.round(2)}%

                Control:
                    Exact Hits:                  #{exact_hits_control}
                    Near Misses:                 #{near_misses_control}
                    Mean Absolute Error:         #{mae_control}
                    Standard Deviation:          #{stdv_control}
                    Mean Absolute Percent Error: #{mape_control*100.round(2)}%
                    Percent Accuracy:            #{(1-accuracy_control)*100.round(2)}%

                Time Stats:
                    Total Time Elapsed (seconds):          #{total_time}
                    Average Time Per Prediction (seconds): #{avg_time_per_predict}
            /
        return s
    end

    def mae(list)
        return (list.inject{|sum, element| sum += element.abs}.to_f/list.length.to_f)
    end

    def stdv(list)
        mean = list.inject{|sum, element| sum += element}.to_f/list.length.to_f
        return Math.sqrt(list.inject{|sum, element| sum += (element-mean)**2}/list.length)
    end

    def mape(real_list, predicted_list)
        return real_list.zip(predicted_list).inject(0) {|sum, list| sum += ((list[0]-list[1])/list[0]).abs}.to_f / real_list.length.to_f
    end
end