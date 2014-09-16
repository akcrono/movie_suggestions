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
  @movies = Movie.paginate_search(@search, @page_number)
  erb :search
end

get '/movies/:movie_id' do
  @movie = Movie.find(params[:movie_id])
  @recommendations = @movie.get_recommendations
  erb :'movies/show'
end
