class AddValidationsToTypes < ActiveRecord::Migration[5.1]
  def self.up
    change_column :types, :name, :string, null: false
    change_column :types, :price, :float, null: false
    change_column :types, :capacity, :integer, null: false
    change_column :types, :group_ticket_no, :integer, null: false, default: 1
    change_column :types, :event_id, :integer, null: false
  end

  def self.down
    change_column :types, :name, :string, null: true
    change_column :types, :price, :float, null: true
    change_column :types, :capacity, :integer, null: true
    change_column :types, :group_ticket_no, :integer, null: true
    change_column :types, :event_id, :integer, null: true
  end
end
