Bloccit::Application.routes.draw do

devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

#nesting comments in posts, posts in topics
  resources :topics do
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]
      match '/up-vote', to: 'votes#up_vote', as: :up_vote
      match '/down-vote', to: 'votes#down_vote', as: :down_vote
  end
end




#mapping /about to welcome/about
  match "about" => 'welcome#about', via: :get

#setting default path
  root :to => 'welcome#index'
end