class AddIndexToProperties < ActiveRecord::Migration
  def change
    add_index :properties, :puzzle_id
  end
end
