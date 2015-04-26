Rails.application.routes.draw do
  get 'sessions/new'

    get 'welcome', to: 'welcome#index'
    resource :calendar, only: :show, controller: 'calendar'

    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'

    resources :accounts, except: :index do
      resources :events
    end

    root 'welcome#index'
end
