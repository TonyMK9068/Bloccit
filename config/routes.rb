Bloccit::Application.routes.draw do

  devise_for :users


#nesting comments in posts, posts in topics

  resources :topics do
    resources :posts, except: [:index] do
  
      resources :comments, only: [:new, :create]
  end


  end

#mapping /about to welcome/about
  match "about" => 'welcome#about', via: :get

#setting default path
  root :to => 'welcome#index'
end