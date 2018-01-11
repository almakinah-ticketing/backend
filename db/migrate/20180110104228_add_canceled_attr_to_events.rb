class AddCanceledAttrToEvents < ActiveRecord::Migration[5.1]
  def self.up
    add_column :events, :canceled, :boolean, null: false, default: false
  end

  def self.down
    remove_column :events, :canceled, :boolean
  end
end
