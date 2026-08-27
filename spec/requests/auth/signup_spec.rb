require "rails_helper"

RSpec.describe "Signup API", type: :request do
  describe "POST /api/sign_up" do
    let(:valid_params) do
      {
        user: {
          "first_name": "Ajai",
          "last_name": "Ganesh",
          "email": "ajai.ganesh7@gmail.com",
          "password": "Bigil@1061",
          "password_confirmation": "Bigil@1061"
        }
      }
    end
    context "with valid parameters" do
      it "creates a new user" do
        expect { post "/api/sign_up", params: valid_params }.to change(User, :count).by(1)
      end
      it "returns 201 created" do
        post "/api/sign_up", params: valid_params
        expect(response).to have_http_status(:created)
      end
      it "return a created user" do
        post "/api/sign_up", params: valid_params
        body = JSON.parse(response.body)
        expect(body["data"]).to eq("Verification email has been sent")
      end
      it "enqueues the verification email job" do
        expect { post "/api/sign_up", params: valid_params }.to have_enqueued_job(SendVerificationEmailJob)
      end
    end
    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            "first_name": "Ajai",
            "last_name": "Ganesh",
            "email": "ajai.ganesh7@gmail.com",
            "password": "Bigil@1061",
            "password_confirmation": "Bigil@106"
          }
        }
      end
      it "doesnt create a user" do
        expect { post "/api/sign_up", params: invalid_params }.not_to change(User, :count)
      end
      it "returns a unprocessable entity" do
        post "/api/sign_up", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it "doesnt enqueue a verfication email" do
        expect { post "/api/sign_up", params: invalid_params }.not_to have_enqueued_job(SendVerificationEmailJob)
      end
    end
  end
end
