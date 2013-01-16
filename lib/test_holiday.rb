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

  def test_assertions
    assert_raise ArgumentError do
      Easter.easter_date("bacon")
    end

    assert_raise ArgumentError do
      Easter.easter_date(-1)
    end
  end
end

class TestHoliday < Test::Unit::TestCase
  def test_fhcreation
    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake Fixed Holiday", "foo", 12)
    end

    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake Fixed Holiday", 2, "bar")
    end

    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake Fixed Holiday", 0, 12)
    end

    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake Fixed Holiday", 13, 12)
    end

    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake Fixed Holiday", 1, 0)
    end

    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake Fixed Holiday", 1, 32)
    end

    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake Fixed Holiday", 2, 29)
    end
  end

  def test_nmhcreation
    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake AM Holiday", "foo", 12)
    end

    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake AM Holiday", 2, "bar")
    end

    assert_raises ArgumentError do
      Holiday::NextMondayHoliday.new("Fake AM Holiday", 0, 12)
    end

    assert_raises ArgumentError do
      Holiday::NextMondayHoliday.new("Fake AM Holiday", 13, 12)
    end

    assert_raises ArgumentError do
      Holiday::NextMondayHoliday.new("Fake AM Holiday", 1, 0)
    end

    assert_raises ArgumentError do
      Holiday::NextMondayHoliday.new("Fake AM Holiday", 1, 32)
    end

    assert_raises ArgumentError do
      Holiday::NextMondayHoliday.new("Fake AM Holiday", 2, 29)
    end
  end

  def test_eohcreation
    assert_raises ArgumentError do
      Holiday::FixedHoliday.new("Fake Easter Offset Holiday", "foo")
    end
  end

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

  def self.hs
    @@hs
  end

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

class TestHolidayParsing < Test::Unit::TestCase
  def test_parsing_fixed
    assert_equal(Holiday::FixedHoliday.new("Anyo Nuevo", 1, 1), Holiday.parse_holiday_spec("FixedHoliday, Anyo Nuevo, 1, 1"))
  end

  def test_parsing_nextmonday
    assert_equal(Holiday::NextMondayHoliday.new("Fiesta de Reyes", 1, 6), Holiday.parse_holiday_spec("NextMondayHoliday, Fiesta de Reyes, 1, 6"))
  end

  def test_parsing_easteroffset
    assert_equal(Holiday::EasterOffsetHoliday.new("Jueves Santo", -3), Holiday.parse_holiday_spec("EasterOffsetHoliday, Jueves Santo, -3"))
  end
end

class TestHolidayAnalysis < Test::Unit::TestCase

  def test_analysis_weekend
    hrs = Holiday.holidays_in_period(Date.new(2011, 1, 1), Date.new(2011, 12, 31), TestHolidaysInPeriod.hs)
    ar = Holiday.analyze(hrs)
    assert_equal(ar[:on_weekend], [
                 Holiday::Holiday.new(Date.new(2011, 1, 1), "Anyo Nuevo"),
                 Holiday::Holiday.new(Date.new(2011, 4, 17), "Domingo de Ramos"),
                 Holiday::Holiday.new(Date.new(2011, 5, 1), "Dia del trabajo"),
                 Holiday::Holiday.new(Date.new(2011, 8, 7), "Batalla de Boyaca"),
                 Holiday::Holiday.new(Date.new(2011, 12, 25), "Navidad"),
    ])
  end

  def test_analysis_dups
    hrs = Holiday.holidays_in_period(Date.new(2011, 1, 1), Date.new(2011, 12, 31), TestHolidaysInPeriod.hs)
    ar = Holiday.analyze(hrs)
    assert_equal(ar[:dups], Hash[Date.new(2011, 7, 4), [
                 Holiday::Holiday.new(Date.new(2011, 7, 4), "Sagrado Corazon"),
                 Holiday::Holiday.new(Date.new(2011, 7, 4), "San Pedro y San Pablo"),
    ]])
  end

  def test_analysis_filtered
    hrs = Holiday.holidays_in_period(Date.new(2011, 1, 1), Date.new(2011, 12, 31), TestHolidaysInPeriod.hs)
    ar = Holiday.analyze(hrs)
    hrs_filtered = hrs.dup
    hrs_filtered.delete(Holiday::Holiday.new(Date.new(2011, 1, 1), "Anyo Nuevo"))
    hrs_filtered.delete(Holiday::Holiday.new(Date.new(2011, 4, 17), "Domingo de Ramos"))
    hrs_filtered.delete(Holiday::Holiday.new(Date.new(2011, 5, 1), "Dia del trabajo"))
    hrs_filtered.delete(Holiday::Holiday.new(Date.new(2011, 8, 7), "Batalla de Boyaca"))
    hrs_filtered.delete(Holiday::Holiday.new(Date.new(2011, 12, 25), "Navidad"))
    hrs_filtered.delete(Holiday::Holiday.new(Date.new(2011, 7, 4), "San Pedro y San Pablo"))
    assert_equal(ar[:effective][6], hrs_filtered[6])
  end

  def test_bug_alldupsremoved
    hrs = Holiday.holidays_in_period(Date.new(2011, 1, 1), Date.new(2011, 12, 31), TestHolidaysInPeriod.hs)
    ar = Holiday.analyze(hrs)
    assert_equal(ar[:effective].find{|n| n == Holiday::Holiday.new(Date.new(2011, 7, 4), "Sagrado Corazon")},
                 Holiday::Holiday.new(Date.new(2011, 7, 4), "Sagrado Corazon"))
  end

end
