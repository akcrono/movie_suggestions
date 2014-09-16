class CreateGenreMovies < ActiveRecord::Migration
  def change
    create_table :genre_movies do |table|
      table.integer :movie_id, null: false
      table.integer :genre_id, null: false

      table.timestamps
    end
  end
end
