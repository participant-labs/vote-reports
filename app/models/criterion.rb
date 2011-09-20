module Criterion
  def self.included(base)
    base.class_eval do
      belongs_to :report
      has_many :evidence, class_name: 'ReportScoreEvidence', dependent: :destroy, as: :criterion

      scope :supported, where(support: true)
      scope :opposed, where(support: false)

      after_save :rescore_report
      delegate :user_id, to: :report
    end
  end

  def position
    support ? 'Support' : 'Oppose'
  end

  def support?
    support
  end

  def oppose?
    !support
  end

  def aligns?(vote)
    (support? && vote.aye?) || (oppose? && vote.nay?)
  end

  def contradicts?(vote)
    (support? && vote.nay?) || (oppose? && vote.aye?)
  end

  def after_destroy
    report.rescore!
  end

  private

  def rescore_report
    report.rescore! if new_record? || support_changed?
  end

end
