namespace :politicians do
  task :latest_term_results do
    # alternative calculation for state:
    # UsState.first(joins: [:senate_terms, :representative_terms],
    # conditions: ["politician_terms.politician_id = ? OR representative_terms_us_states.politician_id = ?", self, self],
    # order: 'COALESCE(politician_terms.ended_on, representative_terms_us_states.ended_on) DESC NULLS LAST')

    ActiveRecord::Base.transaction do
      Politician.find_each do |politician|
        $stdout.print '.'
        $stdout.flush
        latest = politician.terms.latest
        next if latest.nil?
        state = politician.terms.latest(joins: :state).try(:state)
        politician.update_attributes!(state: state, title: latest.title)
      end
    end
  end

  namespace :continuous_terms do
    task regenerate: :environment do
      ContinuousTerm.delete_all
      Politician.find_in_batches do |politicians|
        politicians.each do |politician|
          ContinuousTerm.regenerate_for(politician)
        end
        print '.'
      end
      puts
    end
  end
end
