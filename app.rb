require 'sinatra'
require 'sinatra/activerecord'
# require 'sinatra/reloader'
require 'pry'

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
end

def get_recommendations(movie_id)
  users = User.joins(:reviews).where('reviews.movie_id = ?', movie_id).
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
  best_movies.delete(Movie.find(movie_id).title)
  (best_movies.sort_by { |_, v| [-v[:total_score], v[:total_votes]] }).first(10)
end

get '/' do
  if params[:page]
    @page_number = params[:page].to_i
  else
    @page_number = 1
  end
  @movies = Movie.order(:title).limit(20).offset((@page_number - 1) * 20)
  erb :index
end

get '/search' do
  @search_results = params[:search_results]
  if params[:page]
    @page_number = params[:page].to_i
  else
    @page_number = 1
  end
  @search = "%" + params[:search_results] + "%"
  @movies = Movie.order(:title).where("title ILIKE ?", @search).
                                limit(20).offset((@page_number - 1) * 20)
  erb :search
end

get '/movies/:movie_id' do
  @movie = Movie.find(params[:movie_id])
  @recommendations = get_recommendations(params[:movie_id])
  erb :'movies/show'
end
