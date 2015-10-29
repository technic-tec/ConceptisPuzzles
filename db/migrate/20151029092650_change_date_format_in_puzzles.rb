class ChangeDateFormatInPuzzles < ActiveRecord::Migration
  def up
    change_column :puzzles, :creationDate, :datetime
    change_column :puzzles, :releaseDate, :datetime
  end

  def down
    change_column :puzzles, :creationDate, :date
    change_column :puzzles, :releaseDate, :date
  end
end
