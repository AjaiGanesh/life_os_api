Rails.application.routes.draw do
  scope :api do
    post "sign_up", to: "auth#sign_up"
    get "verify_email", to: "auth#verify_email"
  end
end
