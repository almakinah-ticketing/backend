class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.references :attendee, foreign_key: true
      t.references :type, foreign_key: true

      t.timestamps
    end
  end
end
