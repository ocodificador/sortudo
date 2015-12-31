Rails.application.routes.draw do  
  resources :players
  get '/roll/:player_id', to: 'players#roll'
  get '/enough/:player_id', to: 'players#enough'
  
  root to: "sortudo#index"
end
