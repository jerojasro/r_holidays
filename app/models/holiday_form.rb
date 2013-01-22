class HolidayForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Naming

  attr_accessor :country, :year

  validates_presence_of :year

  def initialize(attributes={})
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end

  def persisted?
    false
  end

end
