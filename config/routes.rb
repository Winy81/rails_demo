Rails.application.routes.draw do
  get 'deals/index'

  root to: 'deals#index'
end
