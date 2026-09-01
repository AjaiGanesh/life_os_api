class Auth::ForgotPasswordService
  def self.call(email)
    return { success: false, errors: "Email is nil or not present", status: :unauthorized } unless email.present?
    user = User.find_by(email: email)
    return { success: false, errors: "Invalid email id", status: :not_found } unless user
    user.reset_password_token = SecureRandom.urlsafe_base64(32)
    user.reset_password_token_expires_at = 15.minutes.from_now
    user.save!
    UserMailer.forgot_password_email(user).deliver_later
    { success: true, data: "Reset Password Email has been sent", status: :ok }
  end
end
