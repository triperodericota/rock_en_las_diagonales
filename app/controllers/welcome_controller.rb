class WelcomeController < ApplicationController

  before_action :authenticate_user!, except: [:index]
  before_action :search_params, only: [:search]

  # GET /
  def index

  end

  # GET /search
  def search
    search_string = "%#{params[:model].html_safe}%"
    @artists = Artist.where.has {name =~ search_string}
    @events = Event.where.has {(title =~ search_string) | (place =~ search_string)}
    @any_result = true unless @artists.empty? & @events.empty?
  end

  private

  def search_params
    params.permit("model")
  end

end
