class Auth::SigninService
  def self.call(email, password)
    user = User.find_by(email: email)
    return { success: false, errors: "Invalid Email or Password", status: :unauthorized } unless user
    return { success: false, errors: "User Account not activated", status: :unauthorized } unless user.active?
    return { success: false, errors: "Invalid Email or Password", status: :unauthorized } unless user.authenticate(password)
    refresh_token, session_id = Auth::SessionService.call(user.id)
    access_token = Auth::JwtService.encode(user.id, session_id)
    { success: true, data: { access_token: access_token, refresh_token: refresh_token }, status: :ok }
  end
end
