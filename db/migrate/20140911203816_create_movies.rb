class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |table|
      table.string :name, null: false
      table.date :release_date
      table.string :imdb_url

      table.timestamps
    end
  end
end
