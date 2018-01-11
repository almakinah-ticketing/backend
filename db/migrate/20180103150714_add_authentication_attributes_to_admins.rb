class AddAuthenticationAttributesToAdmins < ActiveRecord::Migration[5.1]
   def self.up
    remove_column :admins, :password, :string, null: false
    add_column :admins, :password_digest, :string
    add_column :admins, :confirmation_token, :string
    add_column :admins, :confirmed_at, :datetime
    add_column :admins, :confirmation_sent_at, :datetime
  end

  def self.down
    add_column :admins, :password, :string
    remove_column :admins, :password_digest, :string
    remove_column :admins, :confirmation_token
    remove_column :admins, :confirmed_at, :datetime
    remove_column :admins, :confirmation_sent_at, :datetime
  end
end
