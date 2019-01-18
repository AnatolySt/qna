Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: [:destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
