authorization do
  role :admin do
    includes :moderator
    has_permission_on :users, :users_reports, :users_reports_bill_criteria, :users_reports_amendment_criteria, :reports,
      to: [:index, :show, :edit, :update, :new, :create, :destroy]
    has_permission_on :users_adminships, :users_moderatorships, to: [:create, :destroy]
  end

  role :moderator do
    includes :all
    has_permission_on :reports_bill_criteria, to: :autofetch
    has_permission_on :interest_groups, :interest_groups_bill_criteria, :interest_groups_amendment_criteria, :issues, :causes, :causes_reports, to: [:index, :new, :create, :edit, :update, :destroy]
    has_permission_on :interest_groups_images, :causes_images, to: [:edit, :create, :update]
  end

  role :user do
    includes :all
    has_permission_on :user_sessions, to: [:new, :create, :destroy]
    has_permission_on :users, to: [:show, :edit, :update] do
      if_attribute id: is {user.id}
    end
    has_permission_on :users_reports_follows, :causes_follows, :interest_groups_follows, to: [:show, :create, :destroy]
    has_permission_on :users_rpx_identities, to: [:create, :destroy] do
      if_attribute :user_id => is {user.id}
    end
    has_permission_on :reports, :users_reports, :users_reports_bill_criteria, :users_reports_amendment_criteria, :users_reports_thumbnails, to: [:show, :index, :new, :create, :edit, :update, :destroy] do
      if_attribute :user_id => is {user.id}
    end
  end

  role :guest do
    includes :all
    has_permission_on :users, :user_sessions, to: [:new, :create]
  end

  role :all do
    has_permission_on :interest_groups, :issues, :causes, :causes_reports, :causes_scores, to: [:index, :show]
    has_permission_on :reports, :users_reports, to: :index
    has_permission_on :reports, :users_reports, to: :show do
      if_attribute state: ['published', 'unlisted']
    end
  end
end
