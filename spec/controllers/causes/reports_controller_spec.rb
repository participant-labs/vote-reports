require 'rails_helper'

RSpec.describe Causes::ReportsController do
  setup :activate_authlogic

  let(:report) { create(:report, :published, name: "Brady Campaign to Prevent Gun Violence") }
  let(:cause) { create(:cause, name: 'Gun Control') }

  describe 'GET new' do
    context 'as an admin' do
      include_context 'as an admin'

      context 'with a term', :solr do
        def send_request
          get :new, cause_id: cause, term: 'Brady'
        end

        it 'returns related reports' do
          send_request
          expect(assigns[:reports].results).to include(report)
        end

        context 'when the report is on the cause' do
          before { cause.reports << report }

          it 'is not returned' do
            send_request
            expect(assigns[:reports].results).to_not include(report)
          end
        end
      end
    end
  end

  describe 'POST create' do
    context 'as an admin' do
      include_context 'as an admin'

      context 'with a cause report' do
        it 'adds the report' do
          post :create, cause_id: cause, cause: {
            cause_reports_attributes:[{report_id: report.id}]
          }
          expect(cause.reload.reports).to include(report)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let (:cause_report) { cause.cause_reports.create!(report_id: report.id) }

    def send_request
      delete :destroy, cause_id: cause, id: cause_report
    end

    context 'as an admin' do
      include_context 'as an admin'

      it 'removes the report' do
        send_request
        expect(assigns[:cause].reports).to_not include(report)
      end
    end
  end
end
