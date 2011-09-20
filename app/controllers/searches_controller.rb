class SearchesController < ApplicationController
  include PoliticiansHelper

  def show
    params[:in_office] = true
    term = params[:representing] = params[:term]
    @results = Sunspot.search(Report, Politician) do
      fulltext term
      with(:autocompletable, true)
      paginate per_page: 20
    end.results

    respond_to do |format|
      format.html
      format.js {
        @results = @results.map do |r|
          if r.is_a?(Politician)
            {label: render_to_string(partial: 'politicians/search_result', locals: {politician: r}),
            value: politician_title(r),
            path: politician_path(r)}
          elsif r.is_a?(Subject)
            {label: "#{r.name} (Subject)",
            value: r.name,
            path: subject_path(r)}
          elsif r.owner.is_a?(User)
            {label: render_to_string(partial: 'reports/search_result', locals: {report: r}),
              value: r.name, path: user_report_path(r.user, r)}
          else
            { label: render_to_string(partial: 'reports/search_result', locals: {report: r}),
              value: r.name,
              path: polymorphic_path(r.owner)}
          end
        end

        render json: @results.to_json
      }
    end
  end
end
