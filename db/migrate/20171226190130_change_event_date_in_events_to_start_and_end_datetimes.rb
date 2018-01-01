class ChangeEventDateInEventsToStartAndEndDatetimes < ActiveRecord::Migration[5.1]
  def self.up
    remove_column :events, :event_date, :date
    add_column :events, :start_datetime, :datetime
    add_column :events, :end_datetime, :datetime
   end

   def self.down
      add_column :events, :event_date, :date
   end
end
