class Movie < ActiveRecord::Base
  has_many :reviews
  has_many :genre_movies
  has_many :genres, through: :genre_movies

  def get_recommendations
    users = User.joins(:reviews).where('reviews.movie_id = ?', self.id).
        order('reviews.rating').limit(100)

    best_movies = {}
    users.each do |user|
      user_reviews = Review.where(user_id: user.id).order(:rating).limit(20)
      user_reviews.each do |review|
        reviewed_movie_title = review.movie.title
        if best_movies[reviewed_movie_title].nil?
          best_movies[reviewed_movie_title] = { total_score: 0,
              total_votes: 0,
              movie_id: review.movie_id }
        end
        best_movies[reviewed_movie_title][:total_score] += review.rating
        best_movies[reviewed_movie_title][:total_votes] += 1
      end
    end
    best_movies.delete(Movie.find(self.id).title)
    (best_movies.sort_by { |_, v| [-v[:total_score], v[:total_votes]] }).first(10)
  end

  def self.paginate_search(query, page = 1, results_per_page = 20, order = :title)
    order(order).where("title ILIKE ?", query)
        .limit(results_per_page)
        .offset((page - 1) * results_per_page)
  end
end
