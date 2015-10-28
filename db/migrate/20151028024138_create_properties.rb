class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :type
      t.string :name
      t.string :value
      t.string :unit
      t.integer :puzzle_id

      t.timestamps null: false
    end
  end
end
