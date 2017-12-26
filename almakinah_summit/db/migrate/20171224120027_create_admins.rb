class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :f_name
      t.string :l_name
      t.string :email
      t.string :phone_number
      t.string :password

      t.timestamps
    end
  end
end
