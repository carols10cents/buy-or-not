Rails.application.routes.draw do
  root 'home#index'

  get '/auth/discogs/callback' => 'sessions#create'
  get 'auth/failure', to: redirect('/')
  delete '/signout' => 'sessions#destroy'

  get '/collection' => 'collection#show'
  get '/collection/sync' => 'collection#sync'

  get '/releases/:id' => 'releases#show'
end
