require "rails_helper"

RSpec.describe "Dashboard API", type: :request do
  let(:user) { create(:user, status: :active) }

  let!(:session) do
    Session.create!(
      user: user,
      status: :active,
      refresh_token: SecureRandom.urlsafe_base64(32),
      expires_at: 7.days.from_now
    )
  end

  let(:access_token) do
    Auth::JwtService.encode(user.id, session.id)
  end

  describe "GET /api/dashboard" do
    context "when authenticated" do
      before do
        get "/api/dashboard",
            headers: { "Authorization" => access_token }
      end

      it "returns HTTP 200" do
        expect(response).to have_http_status(:ok)
      end

      it "returns a successful response" do
        expect(response.parsed_body["success"]).to be(true)
      end

      it "returns the current date" do
        expect(response.parsed_body.dig("data", "date"))
          .to eq(Date.current.to_s)
      end

      it "returns a greeting" do
        expect(
          response.parsed_body.dig("data", "greeting")
        ).to be_in([
          "Good morning",
          "Good afternoon",
          "Good evening",
          "Good night"
        ])
      end

      it "returns the authenticated user's details" do
        body = response.parsed_body
        dashboard_user = body.dig("data", "user")

        expect(dashboard_user["id"]).to eq(user.id)
        expect(dashboard_user["first_name"]).to eq(user.first_name)
        expect(dashboard_user["last_name"]).to eq(user.last_name)
        expect(dashboard_user["email"]).to eq(user.email)
      end
    end

    context "when the authorization header is missing" do
      it "returns unauthorized" do
        get "/api/dashboard"

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["success"]).to be(false)
      end
    end

    context "when the authorization header is invalid" do
      it "returns unauthorized" do
        get "/api/dashboard",
            headers: { "Authorization" => "Invalid token" }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["success"]).to be(false)
      end
    end

    context "when the user's session is revoked" do
      it "rejects the request" do
        session.update!(
          status: :revoked,
          revoked_at: Time.current
        )

        get "/api/dashboard",
            headers: { "Authorization" => access_token }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when the token is expired" do
      it "returns 401 Unauthorized" do
        allow(JWT).to receive(:decode).and_raise(JWT::ExpiredSignature)

        get "/api/dashboard",
            headers: { "Authorization" => Auth::JwtService.encode(user.id, session.id) }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["errors"]).to be_present
      end
    end

    context "when the Bearer token is malformed" do
      it "returns 401 Unauthorized" do
        get "/api/dashboard",
            headers: { "Authorization" => "Bearer invalid-token" }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["errors"]).to be_present
      end
    end

    context "when the user is deactivated" do
      it "returns 401 Unauthorized" do
        user.update!(status: :deactive)

        get "/api/dashboard",
            headers: { "Authorization" => Auth::JwtService.encode(user.id, session.id) }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["errors"]).to be_present
      end
    end

    context "when the session does not exist" do
      it "returns 401 Unauthorized" do
        token = Auth::JwtService.encode(user.id, "unknown-session-id")

        get "/api/dashboard",
            headers: { "Authorization" => token }

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["errors"]).to be_present
      end
    end
  end

  describe "GET /api/me" do
    it "returns 401 for an unauthenticated request to /api/me" do
      get "/api/me"

      expect(response).to have_http_status(:unauthorized)
      expect(response.parsed_body["errors"]).to be_present
    end
  end
end
