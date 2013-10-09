Bloccit::Application.routes.draw do
  
  devise_for :users


#By calling resources :posts in the resources :topics block
#you are instructing Rails to create nested routes.
  resources :topics do
    resources :posts, except: [:index]
  end

  match "about" => 'welcome#about', via: :get

  root :to => 'welcome#index'
end