class AddResetPasswordDigestToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :reset_password_token, :string
    add_index :users, :reset_password_token
    add_column :users, :reset_password_token_expires_at, :datetime
    add_column :users, :reset_password_verified_at, :datetime
  end
end
