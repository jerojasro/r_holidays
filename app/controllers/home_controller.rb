require 'holiday'
require 'date'

class HomeController < ApplicationController
  def index
  end

  def holidays
    if not params[:country] or not params[:year]
      # TODO fail
    end
    hs = Holiday::holidays_for(params[:country])
    year = params[:year].to_i
    ini = Date.new(year, 1, 1)
    end_ = Date.new(year, 12, 31)
    @hys = Holiday::holidays_in_period(ini, end_, hs)
    render :holidays
  end
end
