Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :creators, only: [:show, :index, :destroy, :update] do
    resources :records, only: [:show, :index, :destroy]

    resources :categories, only: [:show, :index] do
      resources :records, only: [:show, :index, :destroy]
    end
  end

  resources :categories, only: [:show, :index, :destroy, :update] do
    resources :records, only: [:show, :index, :destroy]

    resources :creators, only: [:show, :index] do
      resources :records, only: [:show, :index, :destroy]
    end
  end

  resources :records
end
