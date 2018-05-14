class AddIndexToProperties < ActiveRecord::Migration[5.1]
  def change
    add_index :properties, :puzzle_id
  end
end
