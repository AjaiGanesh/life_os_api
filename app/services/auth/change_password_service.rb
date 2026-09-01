class Auth::ChangePasswordService
  def self.call(current_password, password, password_confirmation, current_user)
    return { success: false, errors: "Current Password is nil or not present", status: :unauthorized } unless current_password.present?
    return { success: false, errors: "New Password is nil or not present", status: :unauthorized } unless password.present?
    return { success: false, errors: "Password Confirmation is nil or not present", status: :unauthorized } unless password_confirmation.present?
    return { success: false, errors: "Password Invalid, Please enter correct Password" } unless current_user.authenticate(current_password)
    current_user.password = password
    current_user.password_confirmation = password_confirmation
    current_user.save!
    current_user&.sessions&.update!(status: :revoked, revoked_at: Time.current)
    { success: true, data: "Password is set for the User Account, Please Sign In", status: :ok }
  end
end
