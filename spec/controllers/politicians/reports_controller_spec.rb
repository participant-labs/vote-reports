require File.dirname(__FILE__) + '/../../spec_helper'

describe Politicians::ReportsController do
  setup :activate_authlogic
  render_views

  let!(:politician) { create(:politician) }
  let!(:report_scores) {
    create_list(:report, 5, :published).map do |report|
      report.scores.for_politicians(politician).first
    end
  }

  describe "GET index" do
    def send_request
      get :index, politician_id: politician
    end

    it "should return reports" do
      send_request
      expect(response).to be_success

      expect(assigns[:politician]).to eq(politician)
      expect(assigns[:scores].to_a).to match_array(report_scores)
    end

    context "when narrowed by subject" do
      def send_request
        get :index, politician_id: politician, subjects: [@report_subject.subject.to_param]
      end

      before do
        @score = report_scores.first
        @report_subject = create(:report_subject, report: @score.report)
      end

      it "should return reports with those subjects" do
        expect(@report_subject.subject.to_param).to_not eq(@report_subject.subject_id.to_s)
        send_request

        expect(response).to be_success

        expect(assigns[:politician]).to eq(politician)
        expect(assigns[:scores].to_a).to match_array([@score])
      end
    end
  end
end
