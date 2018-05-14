class AddSaveLoadUrlToPuzzle < ActiveRecord::Migration[5.1]
  def change
    add_column :puzzles, :save_url, :string
    add_column :puzzles, :load_url, :string
  end
end
