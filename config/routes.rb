Rails.application.routes.draw do
  root to: 'home#index'
  get 'contact', to: 'contact#index'
  get 'pokemons', to:'pokemons#index'
  get '/pokemons/:name', to: 'pokemons#show', as: 'pokemon'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
