class Opposed
  extend ActiveModel::Naming

  def initialize(object)
    @object = object
  end

  attr_reader :object

  def method_missing(*args)
    @object.send(*args)
  end
end
