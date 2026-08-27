class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:resend, :from)
  layout "mailer"
end
