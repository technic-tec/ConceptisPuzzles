class RenameColumnTypeOfProperty < ActiveRecord::Migration[5.1]
  def change
    rename_column :properties, :type, :attr_type
  end
end
