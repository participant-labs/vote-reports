class ForeignKeyConstraintsForCosponsorships < ActiveRecord::Migration
  def up
    remove_foreign_key :bills, column: :sponsorship_id
    add_foreign_key :bills, :cosponsorships, column: :sponsorship_id, dependent: :nullify
  end

  def down
    raise 'nope'
  end
end
