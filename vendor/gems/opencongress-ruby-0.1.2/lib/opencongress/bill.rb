
module OpenCongress

  class OCBill < OpenCongressObject

    attr_accessor :bill_type, :bill_type_human, :id, :introduced, :last_speech, :last_vote_date, :last_vote_roll,
                  :last_vote_where, :last_action, :number, :plain_language_summary,
                  :session, :sponsor, :co_sponsors, :title_full_common, :status,
                  :most_recent_actions, :bill_titles, :recent_blogs, :recent_news, :ident,
                  :title


    def initialize(params)
      params.each do |key, value|
        instance_variable_set("@#{key}", value) if OCBill.instance_methods.include? key
      end
      @bill_type_human, @title = title_full_common.split(' ', 2)
    end

    def ident
      "#{session}-#{bill_type}#{number}"
    end

    def url
      "http://www.opencongress.org/bill/#{ident}/show"
    end

    def self.all_where(params)
      url = construct_url("bills", params)

      if (result = make_call(url))
        parse_results(result)
      end
    end

    def self.most_blogged_bills_this_week
      url = construct_url("most_blogged_bills_this_week", {})
      if (result = make_call(url))
        parse_results(result)
      end
    end

    def self.bills_in_the_news_this_week
      url = construct_url("bills_in_the_news_this_week", {})
      if (result = make_call(url))
        parse_results(result)
      end
    end

    def self.most_tracked_bills_this_week
      url = construct_url("most_tracked_bills_this_week", {})
      if (result = make_call(url))
        parse_results(result)
      end
    end

    def self.most_supported_bills_this_week
      url = construct_url("most_supported_bills_this_week", {})
      if (result = make_call(url))
        parse_results(result)
      end
    end

    def self.most_opposed_bills_this_week
      url = construct_url("most_opposed_bills_this_week", {})
      if (result = make_call(url))
        parse_results(result)
      end
    end

    def self.by_query(q)
      url = OCBill.construct_url("bills_by_query", {:q => q})

      if (result = make_call(url))
        parse_results(result)
      end
    end

    def self.by_idents(idents)
      q = []
      if idents.class.to_s == "Array"
        q = idents
      else
        q = idents.split(',')
      end

      url = OCBill.construct_url("bills_by_ident", {:ident => q.join(',')})

      if (result = make_call(url))
        parse_results(result)
      end
    end

    def opencongress_users_supporting_bill_are_also
      url = OCBill.construct_url("opencongress_users_supporting_bill_are_also/#{ident}", {})
      if (result = OCBill.make_call(url))
        OCBill.parse_supporting_results(result)
      end
    end

    def opencongress_users_opposing_bill_are_also
      url = OCBill.construct_url("opencongress_users_opposing_bill_are_also/#{ident}", {})
      if (result = OCBill.make_call(url))
        OCBill.parse_supporting_results(result)
      end
    end

    def self.parse_results(result)
      (result['bills'] || []).map do |bill|

        bill["recent_blogs"] = (bill["recent_blogs"] || []).map do |trb|
          OCBlogPost.new(trb)
        end

        bill["recent_news"] = (bill["recent_news"] || []).map do |trb|
          OCNewsPost.new(trb)
        end
        bill["co_sponsors"] = (bill["co_sponsors"] || []).map do |tcs|
          OCPerson.new(tcs)
        end

        bill["sponsor"] = OCPerson.new(bill["sponsor"]) if bill["sponsor"]

        OCBill.new(bill)
      end
    end



  end

end
