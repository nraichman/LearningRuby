This app serves as a interface with a movie ranking database.
In my solution, movie_app script acts as the main loop that interacts with the user. It has to be executed with the filename as a command line argument.

movie_app then instantiates a MovieData objects that acts as the data structure that allows interaction with the user.
When MovieData is instantiated, it calls FileReader.read(filename) to parse the data file and return a dictionary of users and a dictionary of movies.

The dictionary of users s comprised of a hash where the keys are user_ids as symbols and the values are user objects. Each user object has an ID and a map of movies they rated. The map of movies each
user rated is a hash from movie ID to the rating the user gave it.

The dictionary of movies in MovieData is comprised of a hash where the keys are movie_ids as symbols and the values are movie objects. Each movie object has a movie ID and a map of users that rated it.
The map of users each movie has is a hash from the user's ID to the rating the user gave this movie.
Movies also have an instance method Movie#popularity which is a method that returns the average rating a movie received. If popularity was calculated before, its value is grabbed from the object's field.
If popularity wasn't calculated before, the movie object parses it's user map and sums up the rating it received from all users, and then divides it by number of users in the map to return the average rating.

MovieData also has the methods MovieData#popularitylist and MovieData#similarity MovieData#most_similar and the helper method MovieData#fit_in_list.

MovieData#popularitylist returns a list of all movies sorted by popularity. This is achieved by sorting the dictionary of movies using a lambda .sort_by{|movie| movie.popularity}

MovieData#similarirty checks the similarity between two given users. In this algorithm we consider the movies that both users rated by using set intersection. We find the distance between their ratings and tally it up.
Next, we consider the movies that only one of the users rated. We consider this to be the largest distance and therefore tally 4 points in difference for each of those movies.
Finally we divide the total difference score over the number of movies considered and then divide that number by four. This gives us an average score of difference between 0 and 1.
We then subtract the difference score from 1 to get the similarity score where 1 is most similar and 0 is completely different.

MovieData#most_similar returns the a list of the 10 most similar users to a given user
This algorithm parses through all users and keeps the 10 users whose similarity to user u is the greatest.
It does so by using a helper method fit_in_list which allows it to check whether an element could be added to the list of 10 greatest.

MovieData#fit_in_list is a helper method checks whether a given element is bigger than or equal to the smallest element in the given list. If it is, it returns smallest user's id so it could be removed.

Questions Discussion:
An algorithm to predict the ranking that a user u would give a movie that they haven't ranked yet:
  On possibility would be to take the ranking that the users in the 10 most similar list gave and find the weighted average according to their score of similarity.
  i.e:
    given a similarity list to user u: user1(rating1, similarity_score1), user2(ranting2, similarity_score2)...user10(rating10, similarity_score10)
    (rating1*ranking1 + rating2*ranking2 + ... + rating10*ranking10)/(ranking1 + ranking2 + ... + ranking 10) = user u's  predicted ranking.

This algorithm doesn't scale well because it requires finding the popularity list for each user which is an O(n^2) algorithm.
This algorithm might be improved if somehow I would infer similar users to user u from a known list of similar users of user w without having to explicitly calculate the similarity list for user u.

Popularity_list algorithm is determined by the number of movies and the number of reviews per movie, and so the run-time O(number of reviews) or at the worst case O(#users*#movies)
most_similar algorithm is determined by the number of users and the number of movies per user. Therfore, its runtime is O(#users*#reviews) or O(#users*#users*#reviews) in the worst case.  
