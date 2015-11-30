class AddSaveLoadUrlToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :save_url, :string
    add_column :puzzles, :load_url, :string
  end
end
