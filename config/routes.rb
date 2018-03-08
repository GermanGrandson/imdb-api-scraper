Rails.application.routes.draw do

  get "/actors/", to: 'scrape#index'

end
