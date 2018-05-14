class AddPublishDateToPuzzle < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :publishDate, :datetime
  end
end
