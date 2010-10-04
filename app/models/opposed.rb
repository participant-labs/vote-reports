class Opposed
  def initialize(object)
    @object = object
  end

  attr_reader :object

  def opposed?
    true
  end

  def to_s
    @object.to_s
  end

  def method_missing(*args)
    @object.send(*args)
  end

  def evidence
    Opposed.new(@object.evidence)
  end
end
