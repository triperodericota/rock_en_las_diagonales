class ArtistsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_artist
  before_action :is_follower?, only: [:show]
  before_action :authenticate_fan!, only: [:show, :index]
  before_action :my_sales_params, only: [:my_sales]

  # GET /artists/1
  # GET /artists/1.json
  def show
    @events = @artist.next_events
   @products = @artist.products
  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'artist was successfully destroyed.' }
    end
  end


  # GET artists/:id/my_sales
  def my_sales
    #@orders = @artist.products.collect {|product| product.orders}.flatten
    current_page = params[:page].nil? ? 1 : params[:page]
    @orders = Order.where(product_id: @artist.products).paginate(:page => current_page, :per_page => 2)
    @total = @artist.products.collect {|product| product.orders}.flatten.
        collect {|order| order.total_price }.reduce(:+)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = Artist.find_by(name: params[:name])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artist_params
      params.require(:artist).permit(:name, :description)
    end

    def is_follower?
      @is_follower = current_user.profile.following? @artist if current_user.fan?
    end

    def my_sales_params
      params.permit(:name, :page)
    end

end
