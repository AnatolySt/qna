Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: [:destroy]
end
