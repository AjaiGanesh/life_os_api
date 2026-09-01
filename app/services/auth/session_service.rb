class Auth::SessionService
  REFRESH_TOKEN_EXPIRY = 7.days.from_now
  def self.call(user_id)
    refresh_token = SecureRandom.urlsafe_base64(64)
    session = Session.new()
    session.user_id = user_id
    session.refresh_token = refresh_token
    session.expires_at = REFRESH_TOKEN_EXPIRY
    session.save!
    [ refresh_token, session.id ]
  end
end
