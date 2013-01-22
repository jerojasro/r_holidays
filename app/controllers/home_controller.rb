require 'holiday'
require 'holiday_form'
require 'date'

class HomeController < ApplicationController

  def new
    @hf = HolidayForm.new
  end

  def show
    @countries = Holiday::countries
  end

  def create

    @hf = HolidayForm.new(params[:holiday_form])

    if @hf.valid?
      redirect_to @hf, notice: 'Post was successfully created.'
    else
      render action: "new"
    end
  end


  def index
    @countries = Holiday::countries
  end

  def hfy(country, year)
    hs = Holiday::holidays_for(country)
    ini = Date.new(year, 1, 1)
    end_ = Date.new(year, 12, 31)
    Holiday::holidays_in_period(ini, end_, hs)
  end

  def holidays
    if not params[:country] or not params[:year]
      # TODO fail
    end
    @year = params[:year].to_i
    @hys = self.hfy(params[:country], @year)
    @analysis = Holiday.analyze(@hys)
    @country = @@countries[params[:country]]
    @country_code = params[:country]
    render :holidays
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
