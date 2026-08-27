class User < ApplicationRecord
  has_many :sessions

  has_secure_password
  enum :status, {
    created: "created",
    active: "active",
    suspended: "suspended"
  }

  validates :first_name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :last_name, allow_blank: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).*\z/
  validates :password, format: { with: PASSWORD_REGEX, message: "must contain uppercase, lowercase, number, and special character" }, length: { minimum: 8 }, if: -> { password.present?}
end
