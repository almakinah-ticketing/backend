class AddImgToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :img, :string
  end
end
