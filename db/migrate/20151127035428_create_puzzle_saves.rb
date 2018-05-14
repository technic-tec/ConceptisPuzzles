class CreatePuzzleSaves < ActiveRecord::Migration[5.1]
  def change
    create_table :puzzle_saves do |t|
      t.integer :puzzle_id
      t.integer :user_id
      t.datetime :first_save
      t.datetime :last_save
      t.integer :total
      t.boolean :solved
      t.string :family_ref
      t.string :variant_ref
      t.string :member_ref
      t.string :serial
      t.text :data

      t.timestamps null: false
    end
    add_index :puzzle_saves, [:puzzle_id, :member_ref]
  end
end
