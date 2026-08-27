require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#verification_email" do
    let(:user) do
      create(
        :user,
        email_verification_digest: "abc123"
      )
    end

    let(:mail) do
      described_class.verification_email(user)
    end

    it "sends to the configured email address" do
      expect(mail.to).to eq(
        [ Rails.application.credentials.dig(:resend, :to).to_s ]
      )
    end

    it "has the correct subject" do
      expect(mail.subject).to eq("Verify you LifeOS account")
    end

    it "contains the verification token in the URL" do
      expect(mail.body.encoded).to include(
        "token=#{user.email_verification_digest}"
      )
    end

    it "contains the application URL" do
      app_url = Rails.application.credentials.dig("app_url")

      expect(mail.body.encoded).to include(app_url)
    end
  end
end
