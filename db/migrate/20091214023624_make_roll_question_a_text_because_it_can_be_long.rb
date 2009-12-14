class MakeRollQuestionATextBecauseItCanBeLong < ActiveRecord::Migration
  def self.up
    change_column :rolls, :question, :text
  end

  def self.down
    change_column :rolls, :question, :string
  end
end
