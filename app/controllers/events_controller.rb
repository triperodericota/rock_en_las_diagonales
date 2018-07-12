class EventsController < ApplicationController

  before_action :authenticate_user!
  before_action :authenticate_artist! , except: [:show, :index]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_artist, except: [:show, :index]
  before_action :is_favourite?, only: [:show]

  # GET /events
  # GET /events.json
  def index
    @all_events = Event.all
    @past_events = @all_events.collect {|e| e.finished?}
    @next_events = @all_events - @past_events
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
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

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to artist_event_path(@artist, @event), notice: 'Event was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to artist_events_url(@artist), notice: 'Event was successfully destroyed.' }
    end
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
      redirect_to(new_user_session_path) unless current_user.profile_type == "Artist"
    end

    def is_favourite?
      if current_user.fan?
        @is_favourite = current_user.profile.is_assistant_for? @event
      end
    end
end
