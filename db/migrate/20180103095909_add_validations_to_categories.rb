class AddValidationsToCategories < ActiveRecord::Migration[5.1]
  def self.up
    change_column :categories, :name, :string, null: false
    change_column :categories, :img, :string, null: false
  end

  def self.down
    change_column :categories, :name, :string
    change_column :categories, :img, :string
  end
end
