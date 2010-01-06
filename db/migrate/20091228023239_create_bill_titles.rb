class CreateBillTitles < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :bill_titles do |t|
        t.text :title, :null => false
        t.string :title_type, :null => false
        t.string :as
        t.integer :bill_id, :null => false

        t.timestamps
      end
      constrain :bill_titles do |t|
        t.bill_id :reference => {:bills => :id, :on_delete => :cascade}
        t.title :not_blank => true
        t.title_type :not_blank => true
        t.as :not_blank => true
      end
      remove_column :bills, :title
    end
  end

  def self.down
    transaction do
      drop_table :bill_titles
      add_column :bills, :title, :text
    end
  end
end
