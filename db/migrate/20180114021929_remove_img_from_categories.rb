class RemoveImgFromCategories < ActiveRecord::Migration[5.1]
  def self.up
    remove_column :categories, :img, :string
  end

  def self.down
    change_column :categories, :img, :string
  end
end
