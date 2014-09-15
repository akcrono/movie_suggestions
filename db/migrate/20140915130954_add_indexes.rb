class AddIndexes < ActiveRecord::Migration
  def change
    add_index :reviews, :user_id
    add_index :reviews, :movie_id
    add_index :genre_movies, :movie_id
    add_index :genre_movies, :genre_id

  end
end
