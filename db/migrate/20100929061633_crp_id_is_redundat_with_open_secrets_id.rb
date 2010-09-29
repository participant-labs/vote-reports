class CrpIdIsRedundatWithOpenSecretsId < ActiveRecord::Migration
  def self.up
    # enforce that crp_id is redundant
    Politician.all(:conditions => 'crp_id is not null').each do |p|
      if !p.open_secrets_id
        p.update_attribute(:open_secrets_id, p.crp_id)
      elsif p.crp_id != p.open_secrets_id
        raise "#{p.crp_id} != #{p.open_secrets_id}"
      end
    end
    remove_column :politicians, :crp_id
  end

  def self.down
    add_column :politicians, :crp_id, :string
  end
end
