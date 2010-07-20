require Rails.root.join('spec/support/blueprints')

Before('@homepagey') do
  create_published_report
  mock(Report).with_scores_for(anything) { Report }
end

Before('@locationy') do
  Marshal.load(open(Rails.root.join('spec/fixtures/districts.marshal'))).map(&:save!)
  mock(District).lookup(anything) { District.all }
end

World(Fixjour)
