class ArtistsController < ApplicationController

  before_action :authenticate_user!, :authenticate_artist

  before_action :new_registration, only: [:new, :create]

  before_action :set_artist, only: [:show, :edit, :update, :destroy]

  # GET /artists
  # GET /artists.json
  def index
    @artists = Artist.all
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
  end

  # GET /artists/new
#  def new
#    @artist = Artist.new
#    @user = @artist.build_user
#  end

  # GET /artists/1/edit
#  def edit
#  end


  # PATCH/PUT /artists/1
  # PATCH/PUT /artists/1.json
#  def update
#    respond_to do |format|
#      if @artist.update(artist_params)
#        format.html { redirect_to @artist, notice: 'Artist was successfully updated.' }
#      else
#        format.html { render :edit }
#      end
#    end
#  end

  # DELETE /artists/1
  # DELETE /artists/1.json
  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: 'Artist was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = Artist.find(params[:name])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def artist_params
      params.require(:artist).permit(:name, :description)
    end

    def new_registration
      redirect_to(root_path) if user_signed_in?
    end

    def authenticate_artist
      redirect_to(new_user_session_path) unless current_user.profile_type == "Artist"
    end

end
