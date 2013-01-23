require 'holiday'

class HolidayForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Naming

  attr_accessor :country, :year

  validates :year, :numericality => { :only_integer => true }
  validates :country, :inclusion => { :in => Holiday.countries.keys, :message => "code invalid" }

  def initialize(attributes={})
    attributes.each do |k, v|
      send("#{k}=", v)
    end
  end

  def persisted?
    false
  end

end
