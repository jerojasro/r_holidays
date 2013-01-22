require 'holiday'
require 'holiday_form'
require 'date'

class HomeController < ApplicationController

  def index
    @countries = Holiday::countries.map{|k, v| [v, k]}
    @hf = HolidayForm.new
  end

  def hfy(country, year)
    hs = Holiday::holidays_for(country)
    ini = Date.new(year, 1, 1)
    end_ = Date.new(year, 12, 31)
    Holiday::holidays_in_period(ini, end_, hs)
  end

  def holidays
    @countries = Holiday::countries.map{|k, v| [v, k]}
    @hf = HolidayForm.new(params[:holiday_form])

    if @hf.valid?
      @year = @hf.year.to_i
      @hys = self.hfy("co", @year)
      @analysis = Holiday.analyze(@hys)
      @country = Holiday::countries["co"]
      @country_code = "co"
      render :holidays
    else
      render action: "new"
    end
  end

  def holidays_csv
    if not params[:country] or not params[:year]
      # TODO fail
    end
    headers["Content-Disposition"] = "attachment; filename=\"holidays_#{params[:country]}_#{params[:year]}.csv\""
    @hys = self.hfy(params[:country], params[:year].to_i)
    render :content_type => 'text/plain', :layout => false
  end

end
