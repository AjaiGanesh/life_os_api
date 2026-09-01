class Auth::ResetPasswordService
  def self.call(password, password_confirmation, token)
    return { success: false, errors: "Password is nil or not present", status: :unauthorized } unless password.present?
    return { success: false, errors: "Password Confirmation is nil or not present", status: :unauthorized } unless password_confirmation.present?
    return { success: false, errors: "Token is nil or not present", status: :unauthorized } unless token.present?
    user = User.find_by(reset_password_token: token)
    return { success: false, errors: "Token not found", status: :not_found } unless user
    return { success: false, errors: "Password reset link has expired. Please request a new one.", status: :unprocessable_entity } if user.reset_password_token_expires_at < Time.current
    user.password = password
    user.password_confirmation = password_confirmation
    user.reset_password_token = nil
    user.reset_password_token_expires_at = nil
    user.reset_password_verified_at = Time.current
    user.save!
    user&.sessions&.update!(status: :revoked, revoked_at: Time.current)
    { success: true, data: "Password is set for the User Account, Please Sign In", status: :ok }
  end
end
