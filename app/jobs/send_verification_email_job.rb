class SendVerificationEmailJob < ApplicationJob
  queue_as :mailers

  retry_on StandardError,
           wait: 5.seconds,
           attempts: 5

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.verification_email(user).deliver_now
  end
end
