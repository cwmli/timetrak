Rails.application.routes.draw do
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
  end
    get 'welcome/index'

    resource :calendar, only: [:show], controller: :calendar

    resources :accounts, except: :index do
      resources :scheduleitems
    end

    root 'welcome#index'
end
