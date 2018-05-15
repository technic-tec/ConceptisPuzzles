class AddUpdatedAtToPuzzleSave < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzle_saves, :created_at, :datetime
    add_column :puzzle_saves, :updated_at, :datetime
  end
end
