Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true do
      member do
        patch :mark_best
      end
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
