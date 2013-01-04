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

  class Holiday
  end

  class FixedHoliday < Holiday

    def initialize(year, month, day)
      @date = Date.new(year, month, day)
    end

  end

  class NextMondayHoliday < Holiday

    attr_reader :date

    def initialize(year, month, day)
      d = Date.new(year, month, day)
      @date = d + ((8 - d.wday) % 7)
    end
  end
end

