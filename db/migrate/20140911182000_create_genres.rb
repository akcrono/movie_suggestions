class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |table|
      table.string :name, null: false

      table.timestamps
    end
  end
end
