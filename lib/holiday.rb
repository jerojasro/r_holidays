require 'date'

module Easter
  def self.easter_date(year)

    raise ArgumentError, "year must be a positive integer: #{year}" unless year.is_a? Fixnum
    raise ArgumentError, "year must be a positive integer: #{year}" unless year >= 0

    a     = year % 19
    b     = year / 100
    c     = year % 100
    d     = b / 4
    e     = b % 4
    f     = (b + 8) / 25
    g     = (b - f + 1) / 3
    h     = ((19 * a) + b - d -g + 15) % 30
    i     = c / 4
    k     = c % 4
    _L    = (32 + (2 * e) + (2 * i) - h - k) % 7
    m     = (a + (11 * h) + (22 * _L)) / 451
    month = (h + _L - (7 * m) + 114) / 31
    day   = 1 + ((h + _L - (7 * m) + 114) % 31)

    Date.new(year, month, day)
    
  end
end

module Holiday

  class HolidaySpec
    attr_reader :name
  end

  module MDHoliday

    attr_reader :month, :day

    def initialize(name, month, day)

      raise ArgumentError, "not a valid month: #{month}" unless month.is_a? Fixnum
      raise ArgumentError, "not a valid month day: #{day}" unless day.is_a? Fixnum
      raise ArgumentError, "month must be between 1 and 12: #{month}" unless month >= 1 and month <= 12

      # leaps day don't matter when defining this kind of holiday
      days_per_month = {1 => 31, 2 => 28, 3 => 31, 4 => 30, 5 => 31, 6 => 30,
                        7 => 31, 8 => 31, 9  => 30, 10 => 31, 11 => 30, 12 => 31}
      raise ArgumentError, "month day must be between 1 and #{days_per_month[month]}: #{day}" unless day >= 1 and day <= days_per_month[month]

      @name = name
      @month = month
      @day = day
    end

    def ==(other)
      other.month == self.month and other.day == self.day and other.name == self.name
    end

  end

  class FixedHoliday < HolidaySpec
    include MDHoliday

    def date(year)
      Date.new(year, @month, @day)
    end

    def self.parse(tokens)

      raise HolidayParseError.new("Incorrect amount of parameters: #{tokens}.  Expecting name, month number and day number") if tokens.size != 3
      name, month_s, day_s = tokens
      self.new(name, month_s.to_i, day_s.to_i)
    end

  end

  class NextMondayHoliday < HolidaySpec
    include MDHoliday

    def date(year)
      d = Date.new(year, @month, @day)
      d + ((8 - d.wday) % 7)
    end

    # TODO this is duplicated with FixedHoliday; can't put it in MDHoliday
    # because including it only adds instance methods
    def self.parse(tokens)

      raise HolidayParseError.new("Incorrect amount of parameters: #{tokens}.  Expecting name, month number and day number") if tokens.size != 3
      name, month_s, day_s = tokens
      self.new(name, month_s.to_i, day_s.to_i)
    end

  end

  class EasterOffsetHoliday < HolidaySpec

    attr_reader :offset

    def initialize(name, offset)
      raise ArgumentError, "not a valid offset: #{offset}" unless offset.is_a? Fixnum
      @name = name
      @offset = offset
    end

    def date(year)
      easter_d = Easter.easter_date(year)
      easter_d + @offset
    end

    def self.parse(tokens)
      raise HolidayParseError.new("Incorrect amount of parameters: #{tokens}.  Expecting name and easter offset") if tokens.size != 2
      name, offset_s = tokens
      self.new(name, offset_s.to_i)
    end

    def ==(other)
      self.name == other.name and self.offset == other.offset
    end
  end

  class Holiday
    include Comparable
    attr_reader :date, :name

    @@wdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    def initialize(date, name)
      @date = date
      @name = name
    end

    def <=>(other)
      rv = @date.<=>(other.date)
      if rv == 0
        return @name.<=>(other.name)
      end
      return rv
    end

    def weekday
      @@wdays[@date.wday]
    end

  end

  def self.holidays_in_period(ini, end_, hs)
    raise ArgumentError, "Invalid initial date: #{ini}" unless ini.is_a? Date
    raise ArgumentError, "Invalid end date: #{end_}" unless end_.is_a? Date
    ini_year = [ini.year, end_.year].min
    end_year = [ini.year, end_.year].max
    hds = []
    (ini_year..end_year).each do |y|
      hs.each do |h|
        hds << Holiday.new(h.date(y), h.name)
      end
    end
    hds.select do |hd|
      hd.date >= ini and hd.date <= end_
    end.sort
  end

  class HolidayParseError < StandardError
  end

  def self.parse_holiday_spec(str)
    str.strip!
    tokens = str.split(",").map{|s| s.strip}
    raise holidayParseError.new("Improper amount of elements") if tokens.size < 1
    ht = tokens[0]
    tokens.shift
    case ht
    when "FixedHoliday"
      FixedHoliday.parse(tokens)
    when "NextMondayHoliday"
      NextMondayHoliday.parse(tokens)
    when "EasterOffsetHoliday"
      EasterOffsetHoliday.parse(tokens)
    else
      raise HolidayParseError.new("Invalid holiday type: #{ht}")
    end
  end

  def self.holidays_for(country_code)
    # TODO validate country code against the table for countries in the home_controller
    hld_path = File.expand_path(File.dirname(__FILE__) + "/hld_data/#{country_code}.hld")
    fail "No holiday file: #{hld_path}" if not File.exists?(hld_path)
    f = File.new(hld_path)
    f.readlines().map do |s|
      parse_holiday_spec s
    end
  end

  # Answers the following questions about the received holiday list:
  #
  # * Which holidays are celebrated on the same date?
  # * Which holidays are celebrated in a weekend?
  # * Which are the effective holidays (not on a weekend, not duplicated) in the received list?
  #
  # the answers are returned in a hashmap
  #
  # NOTE: assumes the received list is already sorted according to each holiday's date
  def self.analyze(hs)
    rv = Hash.new
    rv[:on_weekend] = hs.select{|h| [6, 0].find{|i| i==h.date.wday}} # 6, 0 correspond to ISO weekday numbers for sat, sun
    rv[:dups] = hs.group_by{|n| n.date}.select{|k,v| v.size > 1}
    dup_excl = rv[:dups].map do |k, v|
      v[1,v.size-1]
    end
    excl = rv[:on_weekend] + dup_excl.flatten
    rv[:excl] = excl
    rv[:effective] = hs.select{|h| not excl.find{|he| he==h }}
    rv
  end
end

