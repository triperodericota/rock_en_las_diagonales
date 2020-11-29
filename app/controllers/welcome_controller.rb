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
    if params[:model].present?
      search_string = "%#{params[:model].html_safe}%"
      @artists = Artist.with_search_name(search_string)
      @events = Event.fields_with_input_string(search_string)
      @products = Product.with_search_title(search_string)
      @result = (@artists.to_a << @events.to_a << @products.to_a).flatten.collect do |result_elem|
        class_name = result_elem.class.to_s.downcase
        {'id': class_name + result_elem.id.to_s, name: result_elem.to_s, type: result_elem.class.to_s,
        url: result_elem.base_uri }
      end
    end
    if request.xml_http_request?
      respond_to do |format|
        format.json {
          render json: {result: @result}
        }
      end
    end
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
