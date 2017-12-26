class RemoveDurationFromEvents < ActiveRecord::Migration[5.1]
  def self.up
    remove_column :events, :duration, :float
   end

   def self.down
    add_column :events, :duration, :float    
   end
end
