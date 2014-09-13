class Movie < ActiveRecord::Base
  has_many :reviews
  has_many :genre_movies
  has_many :genres, through: :genre_movies
end
