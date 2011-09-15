class Politicians::RadarsController < ApplicationController
  def show
    @politician = Politician.find(params[:politician_id])
    @cause_scores = Cause.all(order: 'id').map {|cause| [cause.name, cause.report.scores.for_politicians(@politician).first.try(:score) ]}
  end
end
