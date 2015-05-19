Rails.application.routes.draw do
  get 'sessions/new'

    get 'welcome', to: 'welcome#index'
    resource :calendar, only: :show, controller: 'calendar'

    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'

    get '/seasons/details/:id' => 'seasons#details'
    get '/teams/details/:id' => 'teams#details'
    delete '/teams/delete/:id' => 'teams#delete'

    resources :accounts, except: :index do
      resources :seasons
      resources :teams do
        resources :events
      end
    end

    root 'welcome#index'
end
