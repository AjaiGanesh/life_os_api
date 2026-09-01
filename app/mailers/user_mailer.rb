class UserMailer < ApplicationMailer
  def verification_email(user)
    @user = user
    @verification_url = "#{Rails.application.credentials.dig("app_url")}/verify_email?token=#{@user.email_verification_digest}"

    # for dev purpose changed the to_address until verifying the domain
    mail(to: Rails.application.credentials.dig(:resend, :to).to_s, subject: "Verify you LifeOS account")
  end

  def forgot_password_email(user)
    @user = user
    @reset_password_url = "#{Rails.application.credentials.dig("app_url")}/reset_password?token=#{@user.reset_password_token}"

    # for dev purpose changed the to_address until verifying the domain
    mail(to: Rails.application.credentials.dig(:resend, :to).to_s, subject: "Reset Your Password")
  end
end
