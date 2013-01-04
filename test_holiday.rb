require 'test/unit'
require 'date'

require './holiday'

class TestEasterDate < Test::Unit::TestCase
  def test_dates
    assert_equal(Date.new(1983, 4, 3), Easter.easter_date(1983))
    assert_equal(Date.new(1984, 4, 22), Easter.easter_date(1984))
    assert_equal(Date.new(1991, 3, 31), Easter.easter_date(1991))
    assert_equal(Date.new(1996, 4, 7), Easter.easter_date(1996))
    assert_equal(Date.new(2005, 3, 27), Easter.easter_date(2005))
    assert_equal(Date.new(2009, 4, 12), Easter.easter_date(2009))
    assert_equal(Date.new(2012, 4, 8), Easter.easter_date(2012))
  end
end

class TestHoliday < Test::Unit::TestCase
  def test_next_monday_holiday
    assert_equal(Date.new(2013, 1, 7), Holiday::NextMondayHoliday.new(2013, 1, 6).date)
    assert_equal(Date.new(2013, 7, 1), Holiday::NextMondayHoliday.new(2013, 6, 29).date)
    assert_equal(Date.new(2013, 11, 11), Holiday::NextMondayHoliday.new(2013, 11, 11).date)
  end
end
