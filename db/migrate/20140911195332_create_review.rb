class CreateReview < ActiveRecord::Migration
  def change
    create_table :reviews do |table|
      table.integer :user_id, null: false
      table.integer :movie_id, null: false
      table.integer :rating, null: false

      table.timestamps
    end
  end
end
