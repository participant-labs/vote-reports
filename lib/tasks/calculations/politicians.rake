namespace :calculations do
  namespace :politicians do
    task :latest_term_results do
      ActiveRecord::Base.transaction do
        Politician.all.each do |politician|
          $stdout.print '.'
          $stdout.flush
          latest = politician.terms.latest
          next if latest.nil?
          state = politician.terms.latest(:joins => :state).try(:state)
          politician.update_attributes!(:state => state, :title => latest.title)
        end
      end
    end
  end
end