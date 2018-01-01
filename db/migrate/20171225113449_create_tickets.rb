class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.references :attendee
      t.references :type
      t.references :event

      t.timestamps
    end
  end
end
