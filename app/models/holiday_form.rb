class HolidayForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Naming

  attr_accessor :country, :year

  validates :year, :numericality => { :only_integer => true }

  def initialize(attributes={})
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end

  def persisted?
    false
  end

end
