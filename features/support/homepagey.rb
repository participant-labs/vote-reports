Before('@homepagey') do
  create(:report, :published)
  mock(Report).with_scores_for(anything) { Report }
end
