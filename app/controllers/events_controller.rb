class EventsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_artist! , except: [:show, :index, :all_events]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_artist
  before_action :is_favourite?, only: [:show]

  # GET /artists/:artist_name/events
  def index
    @all_events = @artist.events
    @past_events = @all_events.collect {|e| e.finished?}
    @next_events = @all_events - @past_events
  end

  # GET /artists/:artist_name/events/1
  def show
  end

  # GET /artists/:artist_name/events/new
  def new
    @event = Event.new
  end

  # GET artists/:artist_nameevents/1/edit
  def edit
  end

  # POST /artists/:artist_name/events
  def create
    @event = Event.new(event_params)
    @event.artist = @artist
    respond_to do |format|
      if @event.save
        format.html { redirect_to artist_event_path(@artist, @event), notice: 'Event was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /artists/:artist_nameevents/1
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to artist_event_path(@artist, @event), notice: 'Event was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /artists/:artist_name/events/1
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to artist_events_url(@artist), notice: 'Event was successfully destroyed.' }
    end
  end

  # GET /events
  def all_events
    @events = Event.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_artist
      @artist = current_user.profile
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :description, :place, :start_date, :end_date)
    end

    def authenticate_artist!
      redirect_to(new_user_session_path) unless current_user.profile_type == "artist"
    end

    def is_favourite?
      if current_user.fan?
        @is_favourite = current_user.profile.is_assistant_for? @event
      end
    end
end
