class Session < ApplicationRecord
  belongs_to :user

  enum :status, {
    active: "active",
    revoked: "revoked"
  }
end
