require "rails_helper"

RSpec.describe "Verify Email API", type: :request do
  describe "get /api/verify_email" do
    let(:token) { "abc123" }

    let!(:user) do
      create(
        :user,
        status: :created,
        email_verification_digest: token,
        email_verification_expires_at: 15.minutes.from_now,
        email_verified_at: nil
      )
    end

    context "when the token is valid" do
      it "verifies the account" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(response).to have_http_status(:ok)
      end

      it "changes the account status to active" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(user.reload.status).to eq("active")
      end

      it "sets email_verified_at" do
        expect {
          get "/api/verify_email", params: {
            token: token
          }
        }.to change {
          user.reload.email_verified_at
        }.from(nil)
      end

      it "clears the verification token" do
        get "/api/verify_email", params: {
          token: token
        }

        user.reload

        expect(user.email_verification_digest).to be_nil
      end

      it "clears the verification expiry" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(
          user.reload.email_verification_expires_at
        ).to be_nil
      end
    end

    context "when the token does not exist" do
      it "returns not found" do
        get "/api/verify_email", params: {
          token: "invalid-token"
        }

        expect(response).to have_http_status(:not_found)
      end

      it "returns the correct error" do
        get "/api/verify_email", params: {
          token: "invalid-token"
        }

        expect(response.parsed_body["errors"])
          .to eq("Token not found")
      end
    end

    context "when the account is suspended" do
      before do
        user.update!(status: :suspended)
      end

      it "returns forbidden" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(response).to have_http_status(:forbidden)
      end

      it "returns the correct error" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(response.parsed_body["errors"])
          .to eq("Account is already suspended")
      end
    end

    context "when the account is already active" do
      before do
        user.update!(status: :active)
      end

      it "returns conflict" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(response).to have_http_status(:conflict)
      end

      it "returns the correct error" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(response.parsed_body["errors"])
          .to eq("Account is already active")
      end
    end

    context "when the token is expired" do
      before do
        user.update!(
          email_verification_expires_at: 1.minute.ago
        )
      end

      it "returns gone" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(response).to have_http_status(:gone)
      end

      it "returns the correct error" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(response.parsed_body["errors"])
          .to eq("Token is expired")
      end

      it "generates a new verification token" do
        expect {
          get "/api/verify_email", params: {
            token: token
          }
        }.to change {
          user.reload.email_verification_digest
        }.from(token)
      end

      it "extends the verification expiry" do
        get "/api/verify_email", params: {
          token: token
        }

        expect(
          user.reload.email_verification_expires_at
        ).to be > Time.current
      end

      it "enqueues another verification email" do
        expect {
          get "/api/verify_email", params: {
            token: token
          }
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
          .with(user.id)
      end
    end
  end
end
