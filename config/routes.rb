Rails.application.routes.draw do

  get 'deals/index'
  post 'deals/get_deals_of_city'

  root to: 'deals#index'
end
