namespace :cluster do
  def data_for_pols(pols)
    causes = Cause.all(:order => 'id')

    data = Hash[pols.map do |pol|
      scores = causes.map {|cause|  cause.report.scores.for_politicians(pol).first.try(:score) || (0.0 / 0.0) }
      ["#{pol.to_param}-#{pol.location_abbreviation}-#{pol.current_office.party.name rescue nil}", scores]
    end]
    [causes.map(&:name), data]
  end

  task :politicians => :environment do
    require 'rsruby'
    require 'rsruby/dataframe'
    r = RSRuby.instance
    r.class_table['data.frame'] = lambda{|x| DataFrame.new(x)}
    RSRuby.set_default_mode(RSRuby::CLASS_CONVERSION)

    scored_pols = ReportScore.for_causes.all(:select => 'distinct politician_id', :joins => :politician, :conditions => 'politicians.current_office_id is not null').map(&:politician)

    puts "Senators"
    names, values = data_for_pols(scored_pols.select {|p| p.current_office_type == "SenateTerm"})
    data_frame = r.as_data_frame(:x => values, :row_names => names)

    dist = r.dist(:x => data_frame)
    p dist
    result = r.hclust(:d => dist)
    p result
    # r.plot(result)
    # r.pvrect(result, :alpha => 0.95)

    # puts "Representatives"
    # output_csv_for_pols(Rails.root.join('tmp/rep_cause_ratings.csv'), scored_pols.select {|p| p.current_office_type == "RepresentativeTerm"})
    # 
    # puts "All Pols"
    # output_csv_for_pols(Rails.root.join('tmp/all_pol_cause_ratings.csv'), scored_pols)
  end
end
