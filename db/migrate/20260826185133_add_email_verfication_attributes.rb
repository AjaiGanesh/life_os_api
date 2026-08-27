class AddEmailVerficationAttributes < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :email_verification_digest, :string
    add_index :users, :email_verification_digest
    add_column :users, :email_verification_attempts, :integer, default: 0
    add_column :users, :email_verification_expires_at, :datetime
    add_column :users, :email_verified_at, :datetime
  end
end
