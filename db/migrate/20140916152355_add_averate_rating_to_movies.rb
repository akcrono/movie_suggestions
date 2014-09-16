class AddAverateRatingToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :average_rating, :float
  end
end
