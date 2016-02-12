Rails.application.routes.draw do

  get 'motd/index'  =>  'motd#index'
  get 'motd/page1'  =>  'motd#page1'
  get 'page1'  =>  'motd#page1'
  get 'page2'  =>  'motd#page2'
  get 'motd/page2'  =>  'motd#page2'
  post 'page2'  =>  'motd#page2'
  root 'motd#index'

end
