class CreateTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :types do |t|
      t.string :name
      t.float :price
      t.integer :capacity
      t.integer :group_ticket_no
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
