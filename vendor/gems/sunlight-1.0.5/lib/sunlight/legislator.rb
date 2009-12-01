module Sunlight

  class Legislator < Base

    class << self
      #
      # Useful for getting the exact Legislators for a given district.
      #
      # Returns:
      #
      # A Hash of the three Members of Congress for a given District: Two
      # Senators and one Representative.
      #
      # You can pass in lat/long or address. The district will be
      # determined for you:
      #
      #   officials = Legislator.all_for(:latitude => 33.876145, :longitude => -84.453789)
      #   senior = officials[:senior_senator]
      #   junior = officials[:junior_senator]
      #   rep = officials[:representative]
      #
      #   Sunlight::Legislator.all_for(:address => "123 Fifth Ave New York, NY 10003")
      #   Sunlight::Legislator.all_for(:address => "90210") # it'll work, but use all_in_zip instead
      #
      def all_for(params)
        district = District.get(params)
        Legislator.all_in_district(district) if district
      end

      #
      # A helper method for all_for. Use that instead, unless you 
      # already have the district object, then use this.
      #
      # Usage:
      #
      #   officials = Sunlight::Legislator.all_in_district(District.new("NJ", "7"))
      #
      def all_in_district(district)
        senior_senator = Legislator.all_where(:state => district.state, :district => "Senior Seat").first
        junior_senator = Legislator.all_where(:state => district.state, :district => "Junior Seat").first
        representative = Legislator.all_where(:state => district.state, :district => district.number).first

        {:senior_senator => senior_senator, :junior_senator => junior_senator, :representative => representative}
      end

      #
      # A more general, open-ended search on Legislators than #all_for.
      # See the Sunlight API for list of conditions and values:
      #
      # http://services.sunlightlabs.com/api/docs/legislators/
      #
      # Returns:
      #
      # An array of Legislator objects that matches the conditions
      #
      # Usage:
      #
      #   johns = Sunlight::Legislator.all_where(:firstname => "John")
      #   floridians = Sunlight::Legislator.all_where(:state => "FL")
      #   dudes = Sunlight::Legislator.all_where(:gender => "M")
      #
      def all_where(params)
        url = construct_url("legislators.getList", params)

        if result = get_json_data(url)
          result["response"]["legislators"].map do |legislator|
            Legislator.new(legislator["legislator"])
          end
        end
      end
      alias_method :all, :all_where

      #
      # Search for a single legislator.
      # See the Sunlight API for list of conditions and values:
      #
      # http://services.sunlightlabs.com/api/docs/legislators/
      #
      # Returns:
      #
      # A Legislator that matches the conditions, if there is only one match
      # nil, if none is found
      # raises Sunlight::MultipleLegislatorsReturnedError if there are multiple matches
      #
      # Usage:
      #
      #   john = Sunlight::Legislator.find(:firstname => "John")
      #   floridian = Sunlight::Legislator.find(:state => "FL")
      #   dude = Sunlight::Legislator.find(:gender => "M")
      #
      def find(params)
        url = construct_url("legislators.get", params)

        if result = get_json_data(url)
          Legislator.new(result["response"]["legislator"])
        end
      end

      #
      # When you only have a zipcode (and could not get address from the user), use this.
      # It specifically accounts for the case where more than one Representative's district
      # is in a zip code.
      # 
      # If possible, ask for full address for proper geocoding via Legislator#all_for, which
      # gives you a nice hash.
      #
      # Returns:
      #
      # An array of Legislator objects
      #
      # Usage:
      #
      #   legislators = Sunlight::Legislator.all_in_zipcode(90210)
      #
      def all_in_zipcode(zipcode)

        url = construct_url("legislators.allForZip", {:zip => zipcode})
      
        if result = get_json_data(url)
          result["response"]["legislators"].map do |legislator|
            Legislator.new(legislator["legislator"])
          end
        end
      end # def self.all_in_zipcode
    
    
      # 
      # Fuzzy name searching. Returns possible matching Legislators 
      # along with a confidence score. Confidence scores below 0.8
      # mean the Legislator should not be used.
      #
      # The API documentation explains it best:
      # 
      # http://wiki.sunlightlabs.com/index.php/Legislators.search
      #
      # Returns:
      #
      # An array of Legislators, sorted by the fuzzy_score attribute
      #
      # Usage:
      #
      #   legislators = Sunlight::Legislator.search_by_name("Teddy Kennedey")
      #   legislators = Sunlight::Legislator.search_by_name("Johnny Kerry", 0.9)
      #
      def search_by_name(name, threshold = 0.8)
      
        url = construct_url("legislators.search", {:name => name, :threshold => threshold})
      
        if (response = get_json_data(url))
          legislators = response["response"]["results"].compact.map do |result|
            Legislator.new(result["result"]["legislator"].merge("fuzzy_score" => result["result"]["score"].to_f))
          end.select do |legislator|
            legislator.fuzzy_score.to_f > threshold.to_f
          end.sort_by {|l| l.fuzzy_score }.reverse
        
          legislators unless legislators.empty?
        end
      
      end # def self.search_by_name
    end
    
    attr_accessor :title, :firstname, :middlename, :lastname, :name_suffix, :nickname,
                  :party, :state, :district, :gender, :phone, :fax, :website, :webform,
                  :email, :congress_office, :bioguide_id, :votesmart_id, :fec_id,
                  :govtrack_id, :crp_id, :event_id, :eventful_id, :sunlight_old_id,
                  :congresspedia_url, :youtube_url,
                  :twitter_id, :fuzzy_score, :in_office, :senate_class, :birthdate

    # Takes in a hash where the keys are strings (the format passed in by the JSON parser)
    #
    def initialize(params)
      params.each do |key, value|
        value = Time.parse(value) if key == "birthdate" && value && value.size > 0
        instance_variable_set("@#{key}", value) if Legislator.instance_methods.include? key
      end
    end
    
    # Convenience method for getting out the youtube_id from the youtube_url
    def youtube_id
      %r{http://(?:www\.)?youtube\.com/(?:user/)?(.*?)/?$}.match(youtube_url)[1] if youtube_url
    end
    
    # Get the committees the Legislator sits on
    #
    # Returns:
    #
    # An array of Committee objects, each possibly
    # having its own subarray of subcommittees
    def committees
      Committee.all_for_legislator(self)
    end
    
  end # class Legislator

end # module Sunlight
