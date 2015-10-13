Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  match "/users/:id/identities/:provider", to: "identities#destroy", via: %i(get delete), as: :destroy_identity
  match "/users/:id/finish_signup" => "users#finish_signup", via: %i(get patch), as: :finish_signup

  root to: "users#home"
end
