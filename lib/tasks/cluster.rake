namespace :cluster do
  def unpack_clusters(cluster)
    cluster.items.map do |item|
      if item.class == Hierclust::Cluster
        unpack_clusters(item)
      else
        pol = item.data.fetch(:politician)
        "#{pol.to_param}-#{pol.location_abbreviation}-#{pol.current_office.party.name rescue nil}"
      end
    end
  end

  def to_newick(clusters)
    clusters.inspect.gsub('[', '(').gsub(']', ')').gsub('"', '')
  end

  def cluster_pols(pols)
    points = pols.map do |politician|
      scores = Cause.all(:order => 'id').map {|cause|  cause.report.scores.for_politicians(politician).first.try(:score) }
      Hierclust::Point.new(scores, :politician => politician)
    end

    clusterer = Hierclust::Clusterer.new(points, :nils => 50.0, :resolution => 9.0)
    puts to_newick(unpack_clusters(clusterer.clusters.first))
  end

  task :politicians => :environment do
    require 'hierclust'

    scored_pols = ReportScore.for_causes.all(:select => 'distinct politician_id', :joins => :politician, :conditions => 'politicians.current_office_id is not null').map(&:politician)

    puts "Senators"
    puts "=============="
    cluster_pols(scored_pols.select {|p| p.current_office_type == "SenateTerm"})

    puts "Representatives"
    puts "=============="
    cluster_pols(scored_pols.select {|p| p.current_office_type == "RepresentativeTerm"})

    puts "All Pols"
    puts "=============="
    cluster_pols(scored_pols)
  end
end
