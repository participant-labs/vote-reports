VoteReports::Application.routes.draw do
  resource :search, :only => :show
  resources :issues
  resources :embed_reports, :only => :show
  resources :causes do
    resource :embed, :only => :show
    resources :report_scores, :only => [:index, :show]
    resource :follows, :only => [:show, :create, :destroy]
    resources :reports, :only => [:new, :create, :index, :destroy]
    resource :image, :only => [:edit, :create, :update]
  end

  resources :reports, :only => [:index, :new] do
    resources :bill_criteria, :only => [] do
      collection do
        get :autofetch
      end
    end
  end

  resources :users, only: [], path: 'reports' do
    resources :reports, path: '', controller: 'users/reports' do
      resources :report_scores, :only => [:index, :show], controller: 'users/reports/scores'
      resource :embed, :only => :show, controller: 'users/reports/embed'
      resource :follows, :only => [:show, :create, :destroy], controller: 'users/reports/follows'
      resources :causes, :only => :index, controller: 'users/reports/causes'
      resources :subjects, :only => :index, controller: 'users/reports/subjects'
      resource :agenda, :only => :show, controller: 'users/reports/agendas'
      resource :image, :only => [:edit, :update, :create], controller: 'users/reports/thumbnails'
      resources :bill_criteria, :only => [:index, :new, :create, :destroy], controller: 'users/reports/bill_criteria'
      resources :amendment_criteria, :only => [:new, :create, :destroy, :index], controller: 'users/reports/amendment_criteria'
    end
  end

  resources :interest_groups do
    resource :embed, :only => :show
    resource :claim, :only => :new
    resources :report_scores, :only => [:index, :show]
    resource :follows, :only => [:show, :create, :destroy]
    resources :causes, :only => :index
    resources :subjects, :only => :index
    resource :agenda, :only => :show
    resource :image, :only => [:edit, :create, :update]
    resources :bill_criteria, :only => [:index, :new, :create, :destroy]
    resources :amendment_criteria, :only => [:new, :create, :destroy, :index]
  end

  resources :politicians, :only => [:index, :show] do
    resources :causes, :only => :index
    resources :reports, :only => :index
    resource :radar, :only => :show
  end

  resources :subjects, :only => [:index, :show] do
    resources :causes, :only => :index
    resources :reports, :only => :index
    resources :bills, :only => :index
  end

  resources :bills, :only => [:index, :show] do
    resource :titles, :only => :show
    resources :amendments, :only => [:index, :show]
  end

  resources :rolls, :only => [:show]
  resource :location
  resources :guides, :only => [:new, :create, :show] do
    resources :report_scores, :only => :show
  end

  resources :guide_scores, :only => :show
  resources :congressional_districts, :only => "show"
  resources :us_states, :only => "show"
  resources :state_upper_districts, :only => "show"
  resources :state_lower_districts, :only => "show"
  resources :users do
    resources :rpx_identities, :only => [:create, :destroy]
    resource :adminship, :only => [:create, :destroy]
    resource :moderatorship, :only => [:create, :destroy]
    resources :report_scores, :only => :index
  end

  resources :user_sessions
  match '/signup' => 'users#new', :as => :signup
  match '/login' => 'user_sessions#new', :as => :login
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/donate' => 'donations#new', :as => :new_donation
  match '/thanks' => 'donations#show', :as => :donation_thanks
  resource :donations
  match 'about' => 'site#show', :as => :about
  match 'alive' => 'site#alive', :as => :alive
  match '/' => 'site#index', :as => :root

  if Rails.env.development?
    match 'fake_location' => 'site#fake_location', :as => :fake_location
  end
end
