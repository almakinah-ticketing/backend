class AddInvitationsToAdmins < ActiveRecord::Migration[5.1]
  def change
  	add_column :admins, :invitation_token, :string
    add_column :admins, :invited_at, :datetime
  end
end
