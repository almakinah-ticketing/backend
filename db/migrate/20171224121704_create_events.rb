class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :Title
      t.text :overview
      t.text :agenda
      t.date :event_date
      t.float :duration
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
