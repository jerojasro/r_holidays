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
    assert_equal(Date.new(2013, 1, 7), Holiday::NextMondayHoliday.new("Fiesta de Reyes", 1, 6).date(2013))
    assert_equal(Date.new(2013, 7, 1), Holiday::NextMondayHoliday.new("San Pedro y San Pablo", 6, 29).date(2013))
    assert_equal(Date.new(2013, 11, 11), Holiday::NextMondayHoliday.new("Independencia de Cartagena", 11, 11).date(2013))
  end

  def test_easteroffset_holiday
    assert_equal(Date.new(2013, 3, 28), Holiday::EasterOffsetHoliday.new("Jueves Santo", -3).date(2013))
    assert_equal(Date.new(2013, 6, 3), Holiday::EasterOffsetHoliday.new("Corpus Christi", 64).date(2013))
    assert_equal(Date.new(2013, 5, 13), Holiday::EasterOffsetHoliday.new("Ascencion de Jesus", 43).date(2013))
  end
end

class TestHolidaysInPeriod < Test::Unit::TestCase
  @@hs = [
    Holiday::FixedHoliday.new("Anyo Nuevo", 1, 1),
    Holiday::FixedHoliday.new("Dia del trabajo", 5, 1),
    Holiday::FixedHoliday.new("Grito de Independencia", 7, 20),
    Holiday::FixedHoliday.new("Batalla de Boyaca", 8, 7),
    Holiday::FixedHoliday.new("Inmaculada Concepcion", 12, 8),
    Holiday::FixedHoliday.new("Navidad", 12, 25),
    Holiday::NextMondayHoliday.new("Fiesta de Reyes", 1, 6),
    Holiday::NextMondayHoliday.new("San Jose", 3, 19),
    Holiday::NextMondayHoliday.new("San Pedro y San Pablo", 6, 29),
    Holiday::NextMondayHoliday.new("Asuncion de la Virgen", 8, 15),
    Holiday::NextMondayHoliday.new("Dia de la Raza", 10, 12),
    Holiday::NextMondayHoliday.new("Todos los Santos", 11, 1),
    Holiday::NextMondayHoliday.new("Independencia de Cartagena", 11, 11),
    Holiday::EasterOffsetHoliday.new("Domingo de Ramos", -7),
    Holiday::EasterOffsetHoliday.new("Jueves Santo", -3),
    Holiday::EasterOffsetHoliday.new("Viernes Santo", -2),
    Holiday::EasterOffsetHoliday.new("Ascencion de Jesus", 43),
    Holiday::EasterOffsetHoliday.new("Corpus Christi", 64),
    Holiday::EasterOffsetHoliday.new("Sagrado Corazon", 71),
       ]

  def test_holidays_in_period
    assert_equal(Holiday::holidays_in_period(Date.new(2013, 1, 1), Date.new(2013, 12, 31), @@hs).map{|hr| hr.date},
                 [
                   Date.new(2013, 1, 1),
                   Date.new(2013, 1, 7),
                   Date.new(2013, 3, 24),
                   Date.new(2013, 3, 25),
                   Date.new(2013, 3, 28),
                   Date.new(2013, 3, 29),
                   Date.new(2013, 5, 1),
                   Date.new(2013, 5, 13),
                   Date.new(2013, 6, 3),
                   Date.new(2013, 6, 10),
                   Date.new(2013, 7, 1),
                   Date.new(2013, 7, 20),
                   Date.new(2013, 8, 7),
                   Date.new(2013, 8, 19),
                   Date.new(2013, 10, 14),
                   Date.new(2013, 11, 4),
                   Date.new(2013, 11, 11),
                   Date.new(2013, 12, 8),
                   Date.new(2013, 12, 25),
                 ]
                )
  end

  def test_holidays_in_period2
    assert_equal(Holiday::holidays_in_period(Date.new(2013, 1, 7), Date.new(2013, 8, 18), @@hs).map{|hr| hr.date},
                 [
                   Date.new(2013, 1, 7),
                   Date.new(2013, 3, 24),
                   Date.new(2013, 3, 25),
                   Date.new(2013, 3, 28),
                   Date.new(2013, 3, 29),
                   Date.new(2013, 5, 1),
                   Date.new(2013, 5, 13),
                   Date.new(2013, 6, 3),
                   Date.new(2013, 6, 10),
                   Date.new(2013, 7, 1),
                   Date.new(2013, 7, 20),
                   Date.new(2013, 8, 7),
                 ]
                )
  end
end
