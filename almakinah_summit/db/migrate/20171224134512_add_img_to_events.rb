class AddImgToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :img, :string
  end
end
