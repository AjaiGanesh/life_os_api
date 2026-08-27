require "rails_helper"

RSpec.describe SendVerificationEmailJob, type: :job do
  describe "#perform" do
    let(:user) { create(:user) }

    it "uses the mailers queue" do
      expect(described_class.queue_name).to eq("mailers")
    end

    it "sends the verification email" do
      mailer = instance_double(
        ActionMailer::MessageDelivery
      )

      allow(UserMailer)
        .to receive(:verification_email)
        .with(user)
        .and_return(mailer)

      expect(mailer).to receive(:deliver_now)

      described_class.perform_now(user.id)
    end

    it "finds the user using the user id" do
      expect(User)
        .to receive(:find)
        .with(user.id)
        .and_return(user)

      allow(UserMailer)
        .to receive(:verification_email)
        .with(user)
        .and_return(
          instance_double(
            ActionMailer::MessageDelivery,
            deliver_now: true
          )
        )

      described_class.perform_now(user.id)
    end
  end
end
