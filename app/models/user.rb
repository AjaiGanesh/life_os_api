class User < ApplicationRecord
  has_many :sessions

  has_secure_password
  enum :status, {
    created: "created",
    active: "active",
    suspended: "suspended"
  }
end
