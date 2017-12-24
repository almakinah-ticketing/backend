class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :Title, :title
  end
end
