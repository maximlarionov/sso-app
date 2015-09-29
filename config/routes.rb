Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }

  match '/users/:id/identities/:provider', to: 'identities#destroy', via: [:get, :delete], as: :destroy_identity
  match '/users/:id/confirm_email', to: "users#confirm_email", via: [:get], as: :confirm_email
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], as: :finish_signup

  root to: "pages#home"
end
