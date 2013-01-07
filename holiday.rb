require 'date'

module Easter
  def self.easter_date(year)

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

  class FixedHoliday < HolidaySpec

    def initialize(name, month, day)
      @name = name
      @month = month
      @day = day
    end

    def date(year)
      Date.new(year, @month, @day)
    end

  end

  class NextMondayHoliday < HolidaySpec


    def initialize(name, month, day)
      @name = name
      @month = month
      @day = day
    end

    def date(year)
      d = Date.new(year, @month, @day)
      d + ((8 - d.wday) % 7)
    end
  end

  class EasterOffsetHoliday < HolidaySpec
    def initialize(name, offset)
      @name = name
      @offset = offset
    end

    def date(year)
      easter_d = Easter.easter_date(year)
      easter_d + @offset
    end
  end

  class Holiday
    include Comparable
    attr_reader :date, :name
    def initialize(date, name)
      @date = date
      @name = name
    end

    def <=>(other)
      return @date.<=>(other.date)
    end

  end

  def self.holidays_in_period(ini, end_, hs)
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
end

