class Auth::JwtService
  ACCESS_TOKEN_EXPIRY = 15.minutes.from_now.to_i

  def self.encode(user_id, session_id)
    payload = {
      user_id: user_id,
      session_id: session_id,
      exp: ACCESS_TOKEN_EXPIRY
    }
    "Bearer #{JWT.encode(payload, Rails.application.credentials.dig("secret_key_base"))}"
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.dig("secret_key_base"), true, { algorithmm: "HS256" }).first
  end
end
