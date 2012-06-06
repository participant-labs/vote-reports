VoteReports::Application.routes.draw do
  resource :search, only: :show
  resources :issues
  resources :embed_reports, only: :show, controller: 'embeds/reports'
  resources :causes do
    resource :embed, only: :show, controller: 'reports/embeds'
    resources :report_scores, only: [:index, :show], controller: 'causes/scores'
    resource :follows, only: [:show, :create, :destroy], controller: 'causes/follows'
    resources :reports, only: [:new, :create, :index, :destroy], controller: 'causes/reports'
    resource :image, only: [:edit, :create, :update], controller: 'causes/images'
  end

  resources :reports, only: [:index, :new] do
    resources :bill_criteria, only: [], controller: 'reports/bill_criteria' do
      collection do
        get :autofetch
      end
    end
  end

  resources :users, only: [], path: 'reports' do
    resources :reports, path: '', controller: 'users/reports' do
      resources :report_scores, only: [:index, :show], controller: 'users/reports/scores'
      resource :embed, only: :show, controller: 'reports/embeds'
      resource :follows, only: [:show, :create, :destroy], controller: 'users/reports/follows'
      resources :causes, only: :index, controller: 'users/reports/causes'
      resources :subjects, only: :index, controller: 'users/reports/subjects'
      resource :agenda, only: :show, controller: 'users/reports/agendas'
      resource :image, only: [:edit, :update, :create], controller: 'users/reports/thumbnails'
      resources :bill_criteria, only: [:index, :new, :create, :destroy], controller: 'users/reports/bill_criteria'
      resources :amendment_criteria, only: [:new, :create, :destroy, :index], controller: 'users/reports/amendment_criteria'
    end
  end

  resources :interest_groups do
    resource :embed, only: :show, controller: 'interest_groups/embeds'
    resource :claim, only: :new, controller: 'interest_groups/claims'
    resources :report_scores, only: [:index, :show], controller: 'interest_groups/scores'
    resource :follows, only: [:show, :create, :destroy], controller: 'interest_groups/follows'
    resources :causes, only: :index, controller: 'interest_groups/causes'
    resources :subjects, only: :index, controller: 'interest_groups/subjects'
    resource :agenda, only: :show, controller: 'interest_groups/agendas'
    resource :image, only: [:edit, :create, :update], controller: 'interest_groups/images'
    resources :bill_criteria, only: [:index, :new, :create, :destroy], controller: 'interest_groups/bill_criteria'
    resources :amendment_criteria, only: [:new, :create, :destroy, :index], controller: 'interest_groups/amendment_criteria'
  end

  resources :politicians, only: [:index, :show] do
    resources :causes, only: :index, controller: 'politicians/causes'
    resources :reports, only: :index, controller: 'politicians/reports'
    resource :radar, only: :show, controller: 'politicians/radars'
  end

  resources :subjects, only: [:index, :show] do
    resources :causes, only: :index, controller: 'subjects/causes'
    resources :reports, only: :index, controller: 'subjects/reports'
    resources :bills, only: :index, controller: 'subjects/bills'
  end

  resources :bills, only: [:index, :show] do
    resource :titles, only: :show, controller: 'bills/titles'
    resources :amendments, only: [:index, :show], controller: 'bills/amendments'
  end

  resources :rolls, only: [:show]
  resource :location
  resources :guides, only: [:new, :create, :show] do
    resources :report_scores, only: :show, controller: 'guides/scores'
  end

  resources :guide_scores, only: :show
  resources :congressional_districts, only: "show"
  resources :us_states, only: "show"
  resources :state_upper_districts, only: "show"
  resources :state_lower_districts, only: "show"
  resources :users do
    resources :rpx_identities, only: [:create, :destroy], controller: 'users/rpx_identities'
    resource :adminship, only: [:create, :destroy], controller: 'users/adminships'
    resource :moderatorship, only: [:create, :destroy], controller: 'users/moderatorships'
    resources :report_scores, only: :index, controller: 'users/scores'
  end
  resource :dashboard

  resources :user_sessions
  match '/signup' => 'users#new', as: :signup
  match '/login' => 'user_sessions#new', as: :login
  match '/logout' => 'user_sessions#destroy', as: :logout
  match '/donate' => 'donations#new', as: :new_donation
  match '/thanks' => 'donations#show', as: :donation_thanks
  resource :donations
  match 'about' => 'site#show', as: :about
  match 'alive' => 'site#alive', as: :alive
  match '/' => 'site#index', as: :root

  if Rails.env.development?
    match 'fake_location' => 'site#fake_location', as: :fake_location
  end
end
