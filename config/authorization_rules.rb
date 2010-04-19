authorization do
  role :admin do
    has_permission_on [:users, :users_reports], :to => [:index, :show, :edit, :update, :destroy]
    has_permission_on :users_adminships, :to => [:create, :destroy]
  end

  role :user do
    has_permission_on :user_sessions, :to => [:new, :create, :destroy]
    has_permission_on :users, :to => [:show, :edit, :update] do
      if_attribute :id => is {user.id}
    end
    has_permission_on :users_rpx_identities, :to => [:create, :destroy] do
      if_attribute :user_id => is {user.id}
    end
    has_permission_on [:reports, :users_reports], :to => [:show, :index]
    has_permission_on [:reports, :users_reports, :users_reports_bill_criteria, :users_reports_thumbnails], :to => [:show, :index, :new, :create, :edit, :update, :destroy] do
      if_attribute :user_id => is {user.id}
    end
  end

  role :guest do
    has_permission_on [:users, :user_sessions], :to => [:new, :create]
    has_permission_on [:reports, :users_reports], :to => [:show, :index]
  end
end
