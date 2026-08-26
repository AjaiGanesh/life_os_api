Rails.application.routes.draw do
  scope :api do
    post "sign_up", to: "auth#sign_up"
  end
end
