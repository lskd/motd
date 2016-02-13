Rails.application.routes.draw do

  root 'motd#index'
  get '/weatherover',  to: 'motd#weather_rover', as: :weatherover
  post '/weatherover', to: 'motd#weather_rover'
end
