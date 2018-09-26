This project is an implementation of a prediction model for movie rankings.
In solving this problem I have tried several approaches to build accurate and fast models for prediction. When trying each of the approaches I faced different problems as I will elaborate on below. All approaches had one element in common, however. They all rely on finding similar users based on average score per genre. In all approaches but one (the kd-tree approach), I implemented all of the structures and functions, and did not use external libraries.

All approaches below describe a method of finding the most similar users to a given user. In all of them, after finding the most similar users, the rating prediction was based on the average score that those users gave to the movie.


The Methods Attempted:
1. Feature Vectors Plotted in Space
  a.
    Represent each user's average genre scores as a vector and plot it in a 19 dimensional space where each dimension is defined on the integers {0,1,2,3,4,5}
  b.
    for a given user id and movie id, predict the user's score by finding the most similar users and then find the weighted average based on the degree of similarity.

    The degree of similarity is calculated based on cosine similarity between the genre vector of a neighboring user and the user in question.

    The most similar users are found by getting a subspace (hyper cube) of a predefined size (defaults to line length of 1). All users contained within that space are considered similar, and the degree of similarity is determined by cosine similarity.

    Unfortunately, the method I came up with to slice the space was in efficient and so long for the bug data set that my computer froze. The gist of the subspace algorithm was to recursively slice every dimention's hyper planes such that hyper_plane.slice(user_score_for_that_dimention - 1, user_score_for_that_dimention + 1).
    Unfortunately the complexity of such an algorithm is exponential and quickly grew out of hand. It could be shown by the illustration below.

    illustration:
      Let's say we want to find all the neighbors of a user who's genre score vector is [1,5,3,4,2] (shorter than the real one for simplicity)

      And lets say that the 5^5 space in which all our users are plotted is called S.

      Then we must slice out space S such that:

      S.slice(0,2) ---> S[0].slice(4,5) ---> S[0][0].slice(2,4) ---> S[0][0][0].slice(2,4)
                                                                      .
                                                                      .
                                                                      .
                                                                      .
                                             S[0][1].slice(2,4)
                                             S[0][2].slice(2,4)
                                             .
                                             .
                   ---> S[1].slice(4,5) ---> S[1][0].slice(2,4)
                                        ---> S[1][1].slice(2,4)
                                             .
                                             .
                                             .
                   ---> S[2].slice(4,5)

                   ---> S[3].slice(4,5)
                   ---> S[4].slice(4,5)

2. Feature Vectors Represented on A Tree

    a.
      Represent each user as a vector of their average genre score and then add them to a tree such that each level in the tree represents a genre (or a dimension in the vector)
    b.
      The closest neighbors will be found by trimming the tree at each level. The trimming approach is similar to method 1. but this time children that are nil will no be followed, and then the redundant parsing of empty hyper planes is saved.

      Since I came up with the idea myself and tried implementing this myself I must have done something wrong in the tree trimming method since I always ended up with empty sub-trees.

3. K-D Tree

    This is the only method where I used external libraries. For the k-d tree, I used the kanwei/algorithms gem found in "rubydoc.info" and Kanwei's GitHub.

    a.
      In this method each user is again represented by a vector of their average genre scores. This time, however, the users are stored in a k-d tree. A k-d tree is a data structures that allows the storage of k dimensional points such that the lookup time is O(log n) on average, The tree is a binary tree that where each level represents a dimension and the data set is split into two collections of points: those with a dimension value smaller than the pivot on the left, and those with a value greater than the pivot go to the right.

    b.
      Unfortunately, the only gem that I found that implements k-d trees doesn't work properly. I wanted to implement k-d trees myself for this project, but I ran out of time.

4. Simple comparison to of each user genre vector to all other users (The method I ended up using)

    a.
      Represent each user as a vector of their average genre score and then add them to a map where the key is their user_id and the value is their genre vector.
    b.
      The most similar users were found by comparing each user's similarity vector to all other users' similarity vector and keeping the 10 with the highest cosine similarity to the user.
      This method proved to be very slow, but stable and slightly better than control.

5. Simply Returning 4 (Control)

    This method was used as a control and was implemented in validator. For each user in the test set, the prediction given by this method was 4.


The Benchmark:

  It seems that running the program yields decent accuracy.
  The following are the list of tests and their statistics:

  1. Test1: u1.base for training and u1.test for validating.

           The statistics for this run were:

           Test:
               Exact Hits:                  6491
               Near Misses:                 4164
               Mean Absolute Error:         0.9804
               Standard Deviation:          1.3020963324608767
               Mean Absolute Percent Error: 50.56%
               Percent Accuracy:            80.392%

           Control:
               Exact Hits:                  6778
               Near Misses:                 4457
               Mean Absolute Error:         0.9098
               Standard Deviation:          1.153626460584015
               Mean Absolute Percent Error: 57.735%
               Percent Accuracy:            81.804%

           Time Stats:
               Total Time Elapsed (seconds):          157.14932246
               Average Time Per Prediction (seconds): 0.34237325154684095

  2. Test2: u2.base for training and u2.test for validating.

              The statistics for this run were:

              Test:
                Exact Hits:                  6329
                Near Misses:                 4100
                Mean Absolute Error:         0.98705
                Standard Deviation:          1.3021520173370393
                Mean Absolute Percent Error: 50.339999999999996%
                Percent Accuracy:            80.259%

              Control:
                Exact Hits:                  6880
                Near Misses:                 4344
                Mean Absolute Error:         0.89095
                Standard Deviation:          1.1305113978217407
                Mean Absolute Percent Error: 56.45%
                Percent Accuracy:            82.181%

              Time Stats:
                Total Time Elapsed (seconds):          165.855572728
                Average Time Per Prediction (seconds): 0.2539901573169985

  3. Test3: u3.base for training and u3.test for validating.

                The statistics for this run were:

                Test:
                    Exact Hits:                  6531
                    Near Misses:                 3928
                    Mean Absolute Error:         0.96955
                    Standard Deviation:          1.2795378715241887
                    Mean Absolute Percent Error: 51.35999999999999%
                    Percent Accuracy:            80.609%

                Control:
                    Exact Hits:                  6931
                    Near Misses:                 4081
                    Mean Absolute Error:         0.88305
                    Standard Deviation:          1.111536647562804
                    Mean Absolute Percent Error: 56.81%
                    Percent Accuracy:            82.33900000000001%

                Time Stats:
                    Total Time Elapsed (seconds):          157.272708663
                    Average Time Per Prediction (seconds): 0.1809812527767549

  4. Test4: u4.base for training and u4.test for validating.

               The statistics for this run were:

               Test:
                   Exact Hits:                  6510
                   Near Misses:                 4225
                   Mean Absolute Error:         0.9555
                   Standard Deviation:          1.2676030072445494
                   Mean Absolute Percent Error: 47.589999999999996%
                   Percent Accuracy:            80.89%

               Control:
                   Exact Hits:                  6765
                   Near Misses:                 4151
                   Mean Absolute Error:         0.89315
                   Standard Deviation:          1.113220086563728
                   Mean Absolute Percent Error: 56.589999999999996%
                   Percent Accuracy:            82.137%

               Time Stats:
                   Total Time Elapsed (seconds):          151.818539171
                   Average Time Per Prediction (seconds): 0.16448379108450703

  5. Test5: u5.base for training and u5.test for validation.

              The statistics for this run were:

              Test:
                Exact Hits:                  6565
                Near Misses:                 4008
                Mean Absolute Error:         0.96425
                Standard Deviation:          1.2798974736961555
                Mean Absolute Percent Error: 49.33%
                Percent Accuracy:            80.715%

              Control:
                Exact Hits:                  6820
                Near Misses:                 4168
                Mean Absolute Error:         0.89365
                Standard Deviation:          1.1186387746739113
                Mean Absolute Percent Error: 56.64%
                Percent Accuracy:            82.127%

              Time Stats:
                Total Time Elapsed (seconds):          150.665075946
                Average Time Per Prediction (seconds): 0.16252974751456312

  6. Test6: ua.base for training and ua.test for validation.

              The statistics for this run were:

              Test:
                  Exact Hits:                  3051
                  Near Misses:                 2092
                  Mean Absolute Error:         0.9678685047720043
                  Standard Deviation:          1.2972100451236357
                  Mean Absolute Percent Error: 45.72640509013786%
                  Percent Accuracy:            80.64262990455991%

              Control:
                  Exact Hits:                  3316
                  Near Misses:                 2153
                  Mean Absolute Error:         0.8688229056203606
                  Standard Deviation:          1.1201721035090528
                  Mean Absolute Percent Error: 53.49946977730647%
                  Percent Accuracy:            82.6235418875928%

              Time Stats:
                  Total Time Elapsed (seconds):          71.261106019
                  Average Time Per Prediction (seconds): 0.07556851115482502


7. Test ub.base for training and ub.test for validation.

                The statistics for this run were:

                Test:
                    Exact Hits:                  3040
                    Near Misses:                 2066
                    Mean Absolute Error:         0.9670201484623542
                    Standard Deviation:          1.2898580843985739
                    Mean Absolute Percent Error: 46.415694591728524%
                    Percent Accuracy:            80.65959703075292%

                Control:
                    Exact Hits:                  3222
                    Near Misses:                 2208
                    Mean Absolute Error:         0.8786850477200424
                    Standard Deviation:          1.1236771257234155
                    Mean Absolute Percent Error: 53.552492046659594%
                    Percent Accuracy:            82.42629904559915%

                Time Stats:
                    Total Time Elapsed (seconds):          77.084364203
                    Average Time Per Prediction (seconds): 0.08174375843372217


  8. Test u.data for training and u1.test for testing.
                The statistics for this run were:

                Test:
                    Exact Hits:                  7948
                    Near Misses:                 4567
                    Mean Absolute Error:         0.74225
                    Standard Deviation:          1.0321016696188219
                    Mean Absolute Percent Error: 34.855000000000004%
                    Percent Accuracy:            85.155%

                Control:
                    Exact Hits:                  9861
                    Near Misses:                 1933
                    Mean Absolute Error:         0.60485
                    Standard Deviation:          0.8161299705498715
                    Mean Absolute Percent Error: 44.51%
                    Percent Accuracy:            87.90299999999999%

                Time Stats:
                    Total Time Elapsed (seconds):          254.741129099
                    Average Time Per Prediction (seconds): 0.3901089266447167

Analysis:

  The algorithm that I ended up using is the algorithm described in method 4. Unfortunately, since the algorithm involves
  comparing each user to all users to find the list of 10 most similar users, the runtime complexity of the algorithms is
  O(n*m) where n is the number of users and m is the number of movies each user rated.

  Unfortunately, this kind of algorithm doesn't scale well.

  When it comes to the accuracy of the accuracy of the model, the numbers seem pretty consistent across all segments of the data sets (u1, u2, etc.). Therefore, I think that even if the data set was increased the accuracy wouldn't increase. What I think could improve the model is normalizing the vectors before comparison.


Reflection:

  This assignment took me a lot longer than I expected. I got really carried away with trying to build a good model, and ended up spending a lot of time on reading about prediction models and machine learning. I ended up learning a lot of new things about machine learning, and those new ideas that I learned will stick because I implemented (or tried to) them myself. However, while I learned from and enjoyed developing the algorithm, I digressed so much that I ended up not meeting deadlines. I guess that is another lesson I learned from this assignment: to choose my battles and focus on whats important.

  I feel like this assignment gave me a really good feel of programming in Ruby, as it got me introduced to some of my new favorite Ruby idioms, like .map, .inject, and ,reduce.
  
