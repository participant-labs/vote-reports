require 'rails_helper'

RSpec.describe ReportsController do
  setup :activate_authlogic

  describe 'GET new' do
    def send_request
      get :new
    end

    it_behaves_like 'denies visitor'
  end
end
