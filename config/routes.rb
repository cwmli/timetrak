Rails.application.routes.draw do
  get 'sessions/new'

    get 'welcome', to: 'welcome#index'
    resource :calendar, only: :show, controller: 'calendar'

    get    'login'   => 'sessions#new'
    post   'login'   => 'sessions#create'
    delete 'logout'  => 'sessions#destroy'

    get '/events/refresh/' => 'events#refresh'
    get '/events/show/:id' => 'events#show'
    delete '/events/delete/:id' => 'events#delete'

    get '/seasons/details/:id' => 'seasons#details'
    post '/seasons/upload' => 'seasons#upload'

    get '/venues/details/' => 'venues#details'

    get '/teams/details/' => 'teams#details'
    get '/teams/link_to_season/:id' => 'teams#link_to_season'
    get '/teams/unlink_from_season/:id' => 'teams#unlink_from_season'
    delete '/teams/delete/:id' => 'teams#delete'

    get '/calendar/view/' => 'calendar#view' #for readonly view
    get '/calendar/mail/' => 'calendar#mail' #for member mailer
    get '/calendar/all/' => 'calendar#all'
    get '/calendar/retrieve/' => 'calendar#retrieve'
    get '/calendar/generate/' => 'calendar#generate'
    get '/calendar/insert/:id' => 'calendar#insert' #insert team into generated season

    resources :accounts, except: :index do
      resources :seasons do
        resources :venues
      end
      resources :teams do
        resources :events
        resources :members
      end
    end

    root 'welcome#index'
end
