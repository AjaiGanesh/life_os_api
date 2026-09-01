class RenameUsersIdToUserIdInSessions < ActiveRecord::Migration[8.1]
  def change
    rename_column :sessions, :users_id, :user_id
  end
end
