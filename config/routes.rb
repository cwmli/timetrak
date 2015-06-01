Rails.application.routes.draw do
  get 'sessions/new'

    get 'welcome', to: 'welcome#index'
    resource :calendar, only: :show, controller: 'calendar'

    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'

    get '/events/refresh/' => 'events#refresh'
    delete '/events/delete/:id' => 'events#delete'

    get '/seasons/details/:id' => 'seasons#details'
    post '/seasons/upload' => 'seasons#upload'

    get '/venues/details/' => 'venues#details'

    get '/teams/details/' => 'teams#details'
    delete '/teams/delete/:id' => 'teams#delete'

    get '/calendar/all/' => 'calendar#all'
    get '/calendar/retrieve/' => 'calendar#retrieve'
    get '/calendar/generate/' => 'calendar#generate'

    resources :accounts, except: :index do
      resources :seasons do
        resources :venues
      end
      resources :teams do
        resources :events
      end
    end

    root 'welcome#index'
end
