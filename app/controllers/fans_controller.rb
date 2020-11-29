class FansController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_fan!
  before_action :set_fan
  before_action :event_params, only: [:add_event, :remove_event]
  before_action :set_event, only: [:add_event, :remove_event]
  before_action :artist_params, only: [:follow_artist, :unfollow_artist]
  before_action :set_artist, only: [:follow_artist, :unfollow_artist]
  before_action :order_params, only: [:my_purchases]


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

  # GET /fans/:id/my_events
  def my_events
    @all_events = @fan.events
    @past_events = @all_events.select {|e| e.finished?}
    @next_events = @all_events - @past_events
    @other_events = Event.future_events - @all_events
  end

  # GET /fans/:id/followed_artists
  def followed_artists
    @followed_artists = @fan.artists
    @other_artists = (Artist.all - @followed_artists)
  end

  # POST /events/:id/add_event
  def add_event
    @fan.events << @event unless @fan.is_assistant_for? @event
    redirect_to artist_event_path(@event.artist.name,@event)
  end

  # POST /events/:id/remove_event
  def remove_event
    @fan.events.destroy(@event) if @fan.is_assistant_for? @event
    redirect_to artist_event_path(@event.artist.name,@event)
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

  def my_purchases
    current_page = order_params.nil? ? 1 : order_params[:page]
    @orders = @fan.orders.paginate(:page => current_page, :per_page => 2)
  end

  private

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

    def order_params
      params.permit(:id, :page)
    end

end
