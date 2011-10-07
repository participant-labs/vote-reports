class AddForeignKeyConstraintsToCosponsorshipsReallyThisTime < ActiveRecord::Migration
  def change
    missing_ids = Cosponsorship.select('DISTINCT politician_id').map(&:politician_id) - Politician.select('id').map(&:id)
    Cosponsorship.where(politician_id: missing_ids).delete_all
    add_foreign_key :cosponsorships, :politicians
    add_foreign_key :cosponsorships, :bills
  end
end
