class AddValidationsToEvents < ActiveRecord::Migration[5.1]
  def self.up
    change_column :events, :title, :string, null: false
    change_column :events, :overview, :text, null: false
    change_column :events, :agenda, :text, null: false
    change_column :events, :img, :string, null: false
    change_column :events, :event_date, :date, null: false
    change_column :events, :start_datetime, :datetime, null: false
    change_column :events, :end_datetime, :datetime, null: false
    change_column :events, :category_id, :integer, null: false
  end

  def self.down
    change_column :events, :title, :string, null: true
    change_column :events, :overview, :text, null: true
    change_column :events, :agenda, :text, null: true
    change_column :events, :img, :string, null: true
    change_column :events, :event_date, :date, null: true
    change_column :events, :start_datetime, :datetime, null: true
    change_column :events, :end_datetime, :datetime, null: true
    change_column :events, :category_id, :integer, null: true
  end
end
