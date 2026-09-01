class AddRevokedAtToSessions < ActiveRecord::Migration[8.1]
  def change
    add_column :sessions, :revoked_at, :datetime
  end
end
