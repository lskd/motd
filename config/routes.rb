Rails.application.routes.draw do

  root 'motd#index'
  get '/page1'  =>  'motd#page1'
  get '/page2'  =>  'motd#page2'
  post '/page2'  =>  'motd#page2'

end
