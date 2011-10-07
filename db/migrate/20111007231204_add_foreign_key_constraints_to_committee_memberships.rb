class AddForeignKeyConstraintsToCommitteeMemberships < ActiveRecord::Migration
  def change
    add_foreign_key :committee_memberships, :committee_meetings
    add_foreign_key :committee_memberships, :politicians
  end
end
