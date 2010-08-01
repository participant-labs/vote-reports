require Rails.root.join('spec/support/blueprints')

Before('@homepagey') do
  create_published_report
  mock(Report).with_scores_for(anything) { Report }
end

World(Fixjour)
