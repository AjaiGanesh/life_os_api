require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    let(:valid_attributes) do
    {
      "first_name"=> "Ajai",
      "last_name"=> "Ganesh",
      "email"=> "ajai.ganesh7@gmail.com",
      "password"=> "Bigil@1061",
      "password_confirmation"=> "Bigil@1061"
    }
    end

    context "with valid attributes" do
      it "is valid" do
        user = User.new(valid_attributes)
        expect(user).to be_valid
      end
    end

    describe "first name" do
      context "when first name is missing" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(first_name: nil))
          expect(user).not_to be_valid
        end
      end
      context "when firstname name execeeds the length" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(first_name: "nil" * 50))
          expect(user).not_to be_valid
          expect(user.errors[:first_name]).to include("is too long (maximum is 50 characters)")
        end
      end
      context "when firstname doesnt reach the minimum length" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(first_name: "ni"))
          expect(user).not_to be_valid
          expect(user.errors[:first_name]).to include("is too short (minimum is 3 characters)")
        end
      end
    end

    describe "lastname" do
      context "when lastname is blank" do
        it "is valid" do
          user = User.new(valid_attributes.merge(last_name: nil))
          expect(user).to be_valid
        end
      end
      context "when lastname name execeeds the length" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(last_name: "nil" * 50))
          expect(user).not_to be_valid
          expect(user.errors[:last_name]).to include("is too long (maximum is 50 characters)")
        end
      end
      context "when lastname name doesnt reach the minimum length" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(last_name: "ni"))
          expect(user).not_to be_valid
          expect(user.errors[:last_name]).to include("is too short (minimum is 3 characters)")
        end
      end
    end

    describe "email" do
      context "when email is missing" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(email: nil))
          expect(user).not_to be_valid
        end
      end
      context "when email is invalid value" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(email: "invalid_email"))
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include("is invalid")
        end
      end
      context "when email is already taken" do
        before do
          User.create!(valid_attributes)
        end
        it "is invalid" do
          user = User.new(valid_attributes)
          expect(user).not_to be_valid
          expect(user.errors[:email]).to include("has already been taken")
        end
      end
    end

    describe "password" do
      context "when password is missing" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(password: nil))
          expect(user).not_to be_valid
        end
      end
      context "when password is invalid value" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(password: "invalid_email"))
          expect(user).not_to be_valid
          expect(user.errors[:password]).to include("must contain uppercase, lowercase, number, and special character")
        end
      end
      context "when password is doesnt meet the required length" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(password: "Pasrd@1"))
          expect(user).not_to be_valid
          expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
        end
      end
      context "when passwords doesnt match" do
        it "is invalid" do
          user = User.new(valid_attributes.merge(password_confirmation: "diferent_password"))
          expect(user).not_to be_valid
        end
      end
    end
  end
end
