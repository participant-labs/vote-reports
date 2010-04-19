authorization do
  role :admin do
    includes :guest

    has_permission_on [:users, :users_reports], :to => [:index, :show, :edit, :update, :destroy]
    has_permission_on :users_adminships, :to => [:create, :destroy]
  end

  role :user do
    includes :guest

    has_permission_on :users, :to => [:show, :edit, :update] do
      if_attribute :id => is {user.id}
    end
    has_permission_on :users_rpx_identities, :to => [:create, :destroy] do
      if_attribute :user_id => is {user.id}
    end
    has_permission_on :users_reports, :to => [:new, :create, :edit, :update, :destroy] do
      if_attribute :user_id => is {user.id}
    end
    has_permission_on :users_reports_bill_criteria, :to => [:index, :new, :destroy] do
      if_attribute :user_id => is {user.id}
    end
  end

  role :guest do
    has_permission_on :users, :to => [:new, :create]
    has_permission_on :users_reports, :to => [:show, :index]
  end
end
