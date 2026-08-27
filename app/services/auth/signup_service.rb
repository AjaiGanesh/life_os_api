class Auth::SignupService
  def self.call(params)
    user = User.new(params)
    user.email_verification_digest = SecureRandom.urlsafe_base64(32)
    user.email_verification_expires_at = 15.minutes.from_now
    if user.save
      SendVerificationEmailJob.perform_later(user.id)
      { success: true, data: "Verification email has been sent", status: :created }
    else
      { success: false, errors: user.errors.full_messages, status: :unprocessable_entity }
    end
  end
end
