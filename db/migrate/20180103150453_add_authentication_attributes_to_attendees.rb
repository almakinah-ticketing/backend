class AddAuthenticationAttributesToAttendees < ActiveRecord::Migration[5.1]
  def self.up
    remove_column :attendees, :password, :string, null: false
    add_column :attendees, :password_digest, :string, null: false
    add_column :attendees, :confirmation_token, :string
    add_column :attendees, :confirmed_at, :datetime
    add_column :attendees, :confirmation_sent_at, :datetime
  end

  def self.down
    add_column :attendees, :password, :string, null: false
    remove_column :attendees, :password_digest, :string, null: false
    remove_column :attendees, :confirmation_token, :string
    remove_column :attendees, :confirmed_at, :datetime
    remove_column :attendees, :confirmation_sent_at, :datetime
  end
end
