class FansController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_fan!
  before_action :set_fan
  before_action :event_params, only: [:add_event, :remove_event]
  before_action :set_event, only: [:add_event, :remove_event]
  before_action :artist_params, only: [:follow_artist, :unfollow_artist]
  before_action :set_artist, only: [:follow_artist, :unfollow_artist]

  # GET /fans
  # GET /fans.json
  def index
    @fans = Fan.all
  end

  # GET /fans/1
  # GET /fans/1.json
  def show
  end

  # DELETE /fans/1
  # DELETE /fans/1.json
  def destroy
    @fan.destroy
    respond_to do |format|
      format.html { redirect_to fans_url, notice: 'fans was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /events/:id/add_event
  def add_event
    @fan.events << @event unless @fan.is_assistant_for? @event
    redirect_to @event
  end

  # POST /events/:id/remove_event
  def remove_event
    @fan.events.destroy(@event) if @fan.is_assistant_for? @event
    redirect_to @event
  end

  # POST /artists/:name/follow
  def follow_artist
    @fan.artists << @artist unless @fan.following? @artist
    redirect_to @artist
  end

  def unfollow_artist
    @fan.artists.destroy(@artist) if @fan.following? @artist
    redirect_to @artist
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fan
      @fan = current_user.profile
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fan_params
      params.fetch(:fan, {})
    end

    def event_params
      params.permit(:id)
    end

    def set_event
      @event = Event.find(params[:id])
    end

    def artist_params
      params.permit(:name)
    end

    def set_artist
      @artist = Artist.find_by(name: params[:name])
    end

    def authenticate_fan!
      redirect_to(new_user_session_path) unless current_user.profile_type == "Fan"
    end

end
