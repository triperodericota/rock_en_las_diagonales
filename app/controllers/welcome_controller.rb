class WelcomeController < ApplicationController

  before_action :authenticate_user!, except: [:index]
  before_action :search_params, only: [:search]

  # GET /
  def index
    @main_events = Audience.popular_events.collect! {|event| Event.find(event.first)}.to_enum
    @main_artists = Artist.all.sample(3).to_enum
  end

  # GET /search
  def search
    search_string = "%#{params[:model].html_safe}%"
    @artists = Artist.with_search_name(search_string)
    @events = Event.fields_with_input_string(search_string)
    @products = Product.where.has {(title =~ search_string)}
    @any_result = true unless @artists.empty? & @events.empty? & @products.empty?
  end

  def show_cities
    if params[:state].present?
      @cities = CS.cities(params[:state].to_sym, :AR)
    end
    if request.xml_http_request?
      respond_to do |format|
        format.json {
          render json: {cities: @cities}
        }
      end
    end
  end

  private

  def search_params
    params.permit("model")
  end

end
