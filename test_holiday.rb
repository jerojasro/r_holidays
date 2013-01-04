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
