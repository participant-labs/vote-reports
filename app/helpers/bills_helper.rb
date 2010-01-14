module BillsHelper
  def bill_title(bill, options = {})
    if options[:with_date]
      "#{bill.bill_type.to_s} #{bill.bill_number} (#{bill.introduced_on.year}): #{bill.titles.first}"
    else
      "#{bill.bill_type.to_s} #{bill.bill_number}: #{bill.titles.first}"
    end
  end
end
