Rails.application.routes.draw do
  scope :api do
    post "sign_up", to: "auth#sign_up"
    get "verify_email", to: "auth#verify_email"
    post "sign_in", to: "auth#sign_in"
    post "sign_out", to: "auth#sign_out"
    post "sign_out_all", to: "auth#sign_out_all"
    post "refresh", to: "auth#refresh"
    post "forgot_password", to: "auth#forgot_password"
    post "reset_password", to: "auth#reset_password"
    post "change_password", to: "auth#change_password"
    get "me", to: "base#me"
    get "dashboard", to: "dashboard#show"
  end
end
