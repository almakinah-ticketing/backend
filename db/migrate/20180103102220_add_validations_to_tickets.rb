class AddValidationsToTickets < ActiveRecord::Migration[5.1]
  def self.up
    change_column :tickets, :attendee_id, :integer, null: false, foreign_key: true
    change_column :tickets, :type_id, :integer, null: false, foreign_key: true
    change_column :tickets, :event_id, :integer, null: false, foreign_key: true
  end

  def self.down
    change_column :tickets, :attendee_id, :integer, null: true, foreign_key: false
    change_column :tickets, :type_id, :integer, null: true, foreign_key: false
    change_column :tickets, :event_id, :integer, null: true, foreign_key: false
  end
end
