Rails.application.routes.draw do  
  resources :players
  root to: "sortudo#index"
end
