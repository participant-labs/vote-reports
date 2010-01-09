class ConstrainRolls < ActiveRecord::Migration
  def self.up
    change_table :rolls do |t|
      [:aye, :nay, :not_voting, :present, :congress_id, :subject_id].each do |field|
        t.change field, :integer, :null => false
      end

      [:gov_track_id, :where, :result, :required, :roll_type, :subject_type].each do |field|
        t.change field, :string, :null => false
      end

      [:question].each do |field|
        t.change field, :text, :null => false
      end
    end

    constrain :rolls do |t|
      # :roll_type should be included, if not for 103/rolls/h1994-68.xml
      [:where, :result, :required, :subject_type, :question].each do |field|
        t.send(field, :not_blank => true)
      end
      t.congress_id :reference => {:congresses => :id, :on_delete => :cascade}
      t.gov_track_id :not_blank => true, :unique => true
    end    
  end

  def self.down
    change_table :rolls do |t|
      [:aye, :nay, :not_voting, :present, :congress_id, :subject_id].each do |field|
        t.change field, :integer, :null => true
      end

      [:gov_track_id, :where, :result, :required, :roll_type, :subject_type].each do |field|
        t.change field, :string, :null => true
      end

      [:question].each do |field|
        t.change field, :text, :null => false
      end
    end

    deconstrain :rolls do |t|
      [:where, :result, :required, :subject_type, :question].each do |field|
        t.send(field, :not_blank)
      end
      t.congress_id :reference
      t.gov_track_id :not_blank, :unique
    end    
  end
end
