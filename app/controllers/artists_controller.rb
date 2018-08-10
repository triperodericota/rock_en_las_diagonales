class ArtistsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_artist
  before_action :is_follower?, only: [:show]
  before_action :authenticate_fan!, only: [:show, :index]

  # GET /artists
  # GET /artists.json
  def index
    @artists = Artist.all
  end

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

end
