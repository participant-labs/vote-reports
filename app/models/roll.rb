class Roll < ActiveRecord::Base
  PASSAGE_TYPES = [
    "On Passage", "Passage, Objections of the President Notwithstanding", "On Agreeing to the Resolution", "On Agreeing to the Resolution, as Amended", "On Motion to Suspend the Rules and Agree", "On Motion to Suspend the Rules and Agree, as Amended", "On Motion to Suspend the Rules and Pass", "On Motion to Suspend the Rules and Pass, as Amended", "On the Cloture Motion", "On Cloture on the Motion to Proceed"
  ]

  CONSISTENT_TYPES = {
    "On Motion to Suspend the Rules and Pass, as Amended" => ["Suspend Rules and Pass, As Amended", "SUSPEND THE RULES AND PASS, AS AMENDED", "SUSPEND RULES AND PASS, AS AMENDED", "On Motion to Suspend the Rules and Pass, as amended", "SUSPEND THE RULES AND PASS AS AMENDED", "Suspend rules and pass, as amended", "Suspend the Rules and Pass, As Amended", "On motion to Suspend the Rules and Pass, as Amended", "On Motion To Suspend the Rules and Pass, As Amended", "On motion to suspend the rules and pass, as amended", "Suspend the Rules and Pass, as Amended", "On Motion to Suspend the Rules and Pass, As Amended", "ON Motion to Suspend the Rules and Pass, as Amended", "On Motion to Suspend the Rules and Pass, Amended", "On Motion to Supend the Rules and Pass, as Amended", "On Motions to Suspend the Rules and Pass, as Amended", "On motion to Suspend the Rules and Pass, as amended", "On Motion to Suspend Rules and Pass, as Amended", "Motion to Suspend the Rules and Pass, as Amended", "Suspend the Rules and Pass, as amended", "Suspend the rules and Pass, as amended", "SUSPEND THE RULES AND PASS, AS AMENDED .", "Suspend the rules and pass, as amended"],
    "On Motion to Suspend the Rules and Pass" => ["On motion to suspend the rules and pass", "Suspend the Rules and pass", "Supend the rules and pass", "Suspend the rules and pass", "On Motion to Suspend Rules and Pass", "On Motion to Suspend the rules and pass", "Suspend Rules and Pass", "Motion to Suspend the Rules and Pass", "On motion to suspend rules and pass", "Suspend the Rules and Pass", "SUSPEND THE RULES AND PASS"],
    "On Motion to Suspend the Rules and Agree, as Amended" => ["Supend the Rules and Agree, As Amended", "Suspend the rules and agree, as amended", "Suspend the Rules and Agree, as Amended", "Suspend the Rules and Agree, as amended", "On motion to suspend the rules and agree, as amended", "on Motion to Suspend the Rules and Agree, as Amended", "Suspend Rules and Agree, as Amended", "SUSPEND THE RULES AND AGREE AS AMENDED", "On Motion to Suspend the Rules and Agree, As Amended", "SUSPEND THE RULES AND AGREE, AS AMENDED", "On Motion to Suspend the Rules and Agree, as amended", "Suspend rules and agree, as amended", "On Motion to Suspend Rules and Agree, as Amended"],
    "On Motion to Suspend the Rules and Agree" => ["Suspend the Rules and Agree", "Motion to Suspend the Rules and Agree", "On motion to suspend the rules and agree", "SUSPEND THE RULES AND AGREE", "Suspend the Rules and Agree to the Resolution", "Suspend the rules and agree", "On Motion to Suspend Rules and Agree", "On Motion to Suspend the rules and Agree"],
    "On Agreeing to the Amendment, as Amended" => ["On agreeing to the amendment, as amended", "On agreeing to the Amendment, as modified", "on agreeing to the amendment, as amended", "On agreeing to the Amendment, as amended", "On agreeing to the Amendment as modified"],
    "On the Amendment" => ["on agreeing to the amendment", "On agreeing to the amendment"],
    "On Agreeing to the Resolution, as Amended" => ["On Agreeing to the Resolution as Amended", "On agreeing to the resolution, as amended", "On Agreeing to the Resolution, As Amended", "On Agreeing to the Resolution As Amended", "On Agreeing to the Resolution, as amended"],
    "On Agreeing to the Resolution" => ["On the Resolution", "On the Concurrent Resolution", "On Agreeing to the resolution", "ON AGREEING TO THE RESOLUTION", "On the Joint Resolution"],
    "Passage, Objections of the President Notwithstanding" => ["Passage, Objections of the President Not Withstanding", "Passage, objections of the President Notwithstanding", "Passage, objections of the President notwithstanding", "Passage, the Objections of the President Notwithstanding", "Passage, Objection of the President Notwithstanding", "On Overriding the Veto"],
    "On Passage" => ["On Passage of the Bill"]
  }

  has_many :votes, :dependent => :destroy
  belongs_to :subject, :polymorphic => true
  belongs_to :congress

  has_friendly_id :display_name

  named_scope :by_voted_at, :order => "voted_at DESC"
  named_scope :not_on_bill_passage, :conditions => [
    "rolls.roll_type NOT IN(?) AND rolls.subject_type = ?", PASSAGE_TYPES, 'Bill']
  named_scope :on_bill_passage, :conditions => [
    "rolls.roll_type IN(?) AND rolls.subject_type = ?", PASSAGE_TYPES, 'Bill']

  before_validation :set_display_name

  class << self
    def update_roll_types_for_consistency!
      CONSISTENT_TYPES.each_pair do |consistent, inconsistent|
        update_all({:roll_type => consistent}, {:roll_type => inconsistent})
      end
    end
  end

  def passage?
    PASSAGE_TYPES.include?(roll_type)
  end

  def opencongress_url
    "http://www.opencongress.org/vote/#{year}/#{where.first}/#{number}" if congress.current?
  end

private

  def set_display_name
    self.display_name = "#{year}-#{where.first}#{number}" if year.present? && where.present? && number.present?
  end
end
