module ReportsHelper
  def build_criteria_for(report, bills)
    bills.map do |bill|
      report.bill_criteria.find_by_bill_id(bill.id) ||
        report.bill_criteria.build(:bill_id => bill.id)
    end
  end
end
