class CreatePuzzles < ActiveRecord::Migration[5.1]
  def change
    create_table :puzzles do |t|
      t.string :guid
      t.integer :codeFamily
      t.integer :codeVariant
      t.string :codeModel
      t.string :serialNumber
      t.integer :versionMajor
      t.integer :versionMinor
      t.string :builderVersion
      t.date :creationDate
      t.date :releaseDate
      t.text :data

      t.timestamps null: false
    end
  end
end
