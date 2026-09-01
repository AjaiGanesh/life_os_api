class Auth::RefreshTokenService
  def self.call(refresh_token)
    return { success: false, errors: "Refresh token is missing", status: :unauthorized } unless refresh_token
    session = Session.find_by(refresh_token: refresh_token)
    return { success: false, errors: "Invalid Refresh Token", status: :unauthorized } unless session
    return { success: false, errors: "Token is already revoked", status: :unauthorized } if session.revoked?
    return { success: false, errors: "User Account not activated", status: :unauthorized } unless session&.user.active?
    return { success: false, errors: "Token expired Please Sign in Again", status: :unauthorized } if session.expires_at < Time.current
    session.status = :revoked
    session.revoked_at = Time.current
    session.save!
    refresh_token, session_id = Auth::SessionService.call(session.user_id)
    access_token = Auth::JwtService.encode(session.user_id, session_id)
    { success: true, data: { access_token: access_token, refresh_token: refresh_token }, status: :ok }
  end
end
