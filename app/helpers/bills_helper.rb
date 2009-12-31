module BillsHelper
  def bill_title(bill, options = {})
    if options[:with_date]
      "#{bill.bill_type.upcase} #{bill.bill_number} (#{bill.introduced_on.year}): #{bill.title}"
    else
      "#{bill.bill_type.upcase} #{bill.bill_number}: #{bill.title}"
    end
  end
end
