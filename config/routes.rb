Rails.application.routes.draw do
  root 'rooms#index'

  devise_for :users, controllers: { registrations: 'registrations' }
end
