module Sunlight

  class Lobbyist < Base
    attr_accessor :firstname, :middlename, :lastname, :suffix,
                  :official_position, :filings, :fuzzy_score
  
    # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
    #
    def initialize(params)
      params.each do |key, value|    
        instance_variable_set("@#{key}", value) if Lobbyist.instance_methods.include? key
      end
    end

    #
    # Fuzzy name searching of lobbyists. Returns possible matching Lobbyists
    # along with a confidence score. Confidence scores below 0.8
    # mean the lobbyist should not be used.
    #
    # See the API documentation:
    #
    # http://wiki.sunlightlabs.com/index.php/Lobbyists.search
    #
    # Returns:
    #
    # An array of Lobbyists, sorted by the fuzzy_score attribute
    #
    # Usage:
    #
    #   lobbyists = Lobbyist.search("Nisha Thompsen")
    #   lobbyists = Lobbyist.search("Michael Klein", 0.95, 2007)
    #
    def self.search_by_name(name, threshold=0.9, year=Time.now.year)

      url = construct_url("lobbyists.search", :name => name, :threshold => threshold, :year => year)
      
      if (response = get_json_data(url))
        lobbyists = response["response"]["results"].compact.map do |result|
          Lobbyist.new(result["result"]["lobbyist"].merge("fuzzy_score" => result["result"]["score"].to_f))
        end.select do |lobbyist|
          lobbyist.fuzzy_score.to_f > threshold.to_f
        end.sort_by {|l| l.fuzzy_score }.reverse
      
        lobbyists unless lobbyists.empty?
      end
    end # def self.search
  end # class Lobbyist

end