class Auth::VerifyEmailService
  def self.call(token)
    user = User.find_by(email_verification_digest: token)
    return { success: false, errors: "Token not found", status: :not_found } unless user
    return { success: false, errors: "Account is already suspended", status: :forbidden } if user.suspended?
    return { success: false, errors: "Account is already active", status: :conflict } if user.active?
    if Time.current > user.email_verification_expires_at
      user.email_verification_digest = SecureRandom.urlsafe_base64(32)
      user.email_verification_expires_at = 15.minutes.from_now
      user.save!
      SendVerificationEmailJob.perform_later(user.id)
      return { success: false, errors: "Token is expired", status: :gone }
    end
    user.email_verification_digest = nil
    user.email_verification_expires_at = nil
    user.email_verified_at = Time.current
    user.status = :active
    user.save!
    { success: true, data: "Account is verified", status: :ok }
  end
end
