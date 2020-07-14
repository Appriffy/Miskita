class EventsController < ApiController
  before_action :set_event, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: %i[checkaccesstoken getevent]

  # Check access token
  def checkaccesstoken
    email = params["email"]
    accesscode = params["accesscode"]
    if email.present? && accesscode.present?
      if Event.exists?(:access_code => accesscode)
        event = Event.find_by(access_code: accesscode)
        if event.active?
          user = User.find_by(email: email) if User.exists?(:email => email)
          if !user.present?
            user = User.create!(name: email.split("@").first, email: email, password: "password")
          end
          user.watchers.create(user: user, event: event)
          render json: event, status: :ok
        else
          # raise UnprocessableEntity.new('Event expired!')
          render json: { error: 'Event expired!' }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Invalid access key!' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Missing required field!' }, status: :unprocessable_entity
    end
  end

  # GET Event with access token
  def getevent
    accesscode = params["accesscode"]
    if accesscode.present?
      if Event.exists?(:access_code => accesscode)
        event = Event.find_by(access_code: accesscode)
        if event.active?
          render json: event, status: :ok
        else
          render json: { error: 'Event expired!' }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Invalid access key!' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Missing required field!' }, status: :unprocessable_entity
    end
  end

  # GET /events
  def index
    @events = Event.all
    @events = Event.select("id, title").all

    render json: @events
  end

  # GET /events/1
  def show
    # render json: @event
    render json: @event.to_json(:include => { :server => { :only => [:id, :title] }})
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, status: :created, location: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:title, :access_code, :image, :client_email, :client_name, :start_time, :end_time, :server_id)
    end
end
