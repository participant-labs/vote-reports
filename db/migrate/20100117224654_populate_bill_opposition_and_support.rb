class PopulateBillOppositionAndSupport < ActiveRecord::Migration
  def self.up
    transaction do
      Politician.all(:select => 'id').each do |politician|
        supported = politician.rolls.on_bill_passage.supported.all(:select => 'DISTINCT subject_id').map do |roll|
          [politician.id, roll.subject_id]
        end
        BillSupport.import_without_validations_or_callbacks [:politician_id, :bill_id], supported if supported.present?

        opposed =   politician.rolls.on_bill_passage.opposed.all(:select => 'DISTINCT subject_id').map do |roll|
            [politician.id, roll.subject_id]
          end
        BillOpposition.import_without_validations_or_callbacks [:politician_id, :bill_id], opposed if opposed.present?
          
        $stdout.print '.'
        $stdout.flush
      end
    end
  end

  def self.down
    BillSupport.delete_all
    BillOpposition.delete_all
  end
end
