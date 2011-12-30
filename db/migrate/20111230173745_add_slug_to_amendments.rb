class AddSlugToAmendments < ActiveRecord::Migration
  def change
    add_column :amendments, :slug, :string
  end
end
