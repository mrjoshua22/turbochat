Rails.application.routes.draw do
  root 'rooms#index'

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :messages, only: :create do
    member { post :like }
  end

  resources :rooms, only: %i[create index show], param: :title
end
