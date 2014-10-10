require 'spec_helper'

describe Causes::ScoresController do
  let(:cause) { create(:cause) }

  describe 'GET index' do
    def send_request
      get :index, cause_id: cause, format: format
    end

    context 'with format json' do
      let(:format) { :json }

      it 'succeeds' do
        send_request
        expect(response).to be_success
      end
    end
  end

  describe 'GET show' do
    let(:score) { create(:report_score, report: cause.report) }

    def send_request
      get :show, cause_id: cause, id: score, format: format
    end

    context 'with format html' do
      let(:format) { :html }

      it 'succeeds' do
        send_request
        expect(response).to be_success
      end
    end

    context 'with format js' do
      let(:format) { :js }

      it 'succeeds' do
        send_request
        expect(response).to be_success
      end
    end
  end
end
