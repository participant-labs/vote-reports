Before('@homepagey') do
  create(:report, :published)
  allow(Report).to receive(:with_scores_for).and_return(Report)
end
