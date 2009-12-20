class AnnotateForeignKeyDependencyBehavior < ActiveRecord::Migration
  def self.up
    transaction do
      remove_foreign_key "amendments", "bills"

      remove_foreign_key "bill_criteria", "bills"
      remove_foreign_key "bill_criteria", "reports"

      remove_foreign_key "bills", "congresses"
      remove_foreign_key "bills", :column => 'sponsor_id'

      remove_foreign_key "reports", "users"

      remove_foreign_key "representative_terms", "congresses"
      remove_foreign_key "representative_terms", "politicians"

      remove_foreign_key "rolls", "congresses"

      remove_foreign_key "senate_terms", "congresses"
      remove_foreign_key "senate_terms", "politicians"

      remove_foreign_key "votes", "politicians"
      remove_foreign_key "votes", "rolls"
    
      change_table "amendments" do |t|
        t.foreign_key "bills", :dependent => :delete
      end

      change_table "bill_criteria" do |t|
        t.foreign_key "bills", :dependent => :delete
        t.foreign_key "reports", :dependent => :delete
      end

      change_table "bills" do |t|
        t.foreign_key "congresses", :dependent => :delete
        t.foreign_key "politicians", :column => "sponsor_id", :dependent => :nullify
      end

      change_table "reports" do |t|
        t.foreign_key "users", :dependent => :delete
      end

      change_table "representative_terms" do |t|
        t.foreign_key "congresses", :dependent => :delete
        t.foreign_key "politicians", :dependent => :delete
      end

      change_table "rolls" do |t|
        t.foreign_key "congresses", :dependent => :delete
      end

      change_table "senate_terms" do |t|
        t.foreign_key "congresses", :dependent => :delete
        t.foreign_key "politicians", :dependent => :delete
      end

      change_table "votes" do |t|
        t.foreign_key "politicians", :dependent => :delete
        t.foreign_key "rolls", :dependent => :delete
      end
    end
  end

  def self.down
    transaction do
      remove_foreign_key "amendments", "bills"

      remove_foreign_key "bill_criteria", "bills"
      remove_foreign_key "bill_criteria", "reports"

      remove_foreign_key "bills", "congresses"
      remove_foreign_key "bills", "politicians"

      remove_foreign_key "reports", "users"

      remove_foreign_key "representative_terms", "congresses"
      remove_foreign_key "representative_terms", "politicians"

      remove_foreign_key "rolls", "congresses"

      remove_foreign_key "senate_terms", "congresses"
      remove_foreign_key "senate_terms", "politicians"

      remove_foreign_key "votes", "politicians"
      remove_foreign_key "votes", "rolls"
    
      change_table "amendments" do |t|
        t.foreign_key "bills"
      end

      change_table "bill_criteria" do |t|
        t.foreign_key "bills"
        t.foreign_key "reports"
      end

      change_table "bills" do |t|
        t.foreign_key "congresses"
        t.foreign_key "politicians", :column => "sponsor_id"
      end

      change_table "reports" do |t|
        t.foreign_key "users"
      end

      change_table "representative_terms" do |t|
        t.foreign_key "congresses"
        t.foreign_key "politicians"
      end

      change_table "rolls" do |t|
        t.foreign_key "congresses"
      end

      change_table "senate_terms" do |t|
        t.foreign_key "congresses"
        t.foreign_key "politicians"
      end

      change_table "votes" do |t|
        t.foreign_key "politicians"
        t.foreign_key "rolls"
      end
    end
  end
end
