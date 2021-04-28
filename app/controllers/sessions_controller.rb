class SessionsController < ApplicationController
  def create
    @user = User.find_by(username: session_params[:username])

    if @user&.authenticate(session_params[:password])
      login!
      token = encode({ user_id: @user.id })
      render json: {
        logged_in: true,
        user: @user,
        token: token
      }
    else
      render json: {
        status: 401,
        errors: ['No such user', 'Verify credentials and try again or signup']
      }
    end
  end

  def islogged_in?
    token = request.headers['Authenticate']
    user = User.find(decode(token)['user_id'])

    if logged_in? && current_user && user
      render json: {
        logged_in: true,
        user: user
      }
    else
      render json: {
        logged_in: false,
        message: 'No such user'
      }
    end
  end

  def destroy
    logout!
    render json: {
      status: 200,
      logged_out: true
    }
  end

  private

  def session_params
    params.require(:user).permit(:username, :email, :password)
  end
end
