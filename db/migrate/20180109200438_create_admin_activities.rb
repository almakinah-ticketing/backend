class CreateAdminActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_activities do |t|
      t.references :admin, foreign_key: true
      t.references :event, foreign_key: true
      t.string :action, null: false

      t.timestamps
    end
  end
end
