# app/controllers/users_controller.rb
class UsersController < ApiController
  skip_before_action :authenticate_request, only: %i[login register forgot email_test getevents]

  # GET All events
  def getevents
    email = params["email"]
    if email.present? && User.exists?(:email => email)
      user = User.find_by(email: email)
      render json: user.events, status: :created 
    else
      render json: { message: 'No data' }, status: :ok
    end
  end

  # POST /register
  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully'}
      UserMailer.with(user: @user).welcome_email.deliver_later
      render json: response, status: :created 
    else
      render json: @user.errors, status: :bad
    end 
  end

  def login
    authenticate params[:email], params[:password]
  end

  def forgot_password
    if params[:email].blank? # check if email is present
      return render json: {error: 'Email not present'}
    end

    user = User.find_by(email: params[:email]) # if present find user by email

    if user.present?
      user.generate_password_token! #generate pass token
      # SEND EMAIL HERE
      render json: {status: 'ok'}, status: :ok
    else
      render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
    end
  end

  def change_password
    user = @current_user
    user.password = params[:new_password]

    if user.save
      response = { message: 'User updated successfully'}
      render json: response, status: :success 
    else
      render json: @user.errors, status: :bad
    end 
  end

  def test
    render json: {
          message: 'You have passed authentication and authorization test'
        }
  end

  def email_test
    UserMailer.welcome_email(User.last).deliver
    render json: {
          message: 'Email test'
        }
  end
   
  private
  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
    
  def user_params
    params.permit(
      :name,
      :email,
      :password
    )
  end
end
