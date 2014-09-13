class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |table|
      table.integer :age
      table.string :gender
      table.string :occupation
      table.integer :zip_code

      table.timestamps
    end
  end
end
