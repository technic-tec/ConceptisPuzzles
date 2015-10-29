class RenameColumnTypeOfProperty < ActiveRecord::Migration
  def change
    rename_column :properties, :type, :attr_type
  end
end
