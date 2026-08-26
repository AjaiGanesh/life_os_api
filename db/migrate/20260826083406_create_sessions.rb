class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :users, type: :uuid, foreign_key: true, null: false
      t.string :refresh_token, null: false
      t.datetime :expires_at, null: false
      t.string :status, default: "active"
      t.timestamps
    end
    add_index :sessions, :refresh_token, unique: true
  end
end
