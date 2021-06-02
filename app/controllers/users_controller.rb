class UsersController < ApplicationController
  def index
    @users = User.all
    p @users
    if @users
      render json: {
        users: @users
      }, include: :listing, except: %i[created_at updated_at]
    else
      render json: {
        status: 500,
        errors: ['No users found']
      }
    end
  end

  def show
    @user = User.find_by(username: params[:username])
    if @user
      render json: {
        user: @user
      }
    else
      render json: {
        status: 500,
        errors: ['User not found']
      }
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login!
      render json: {
        status: :created,
        user: @user
      }
    else
      render json: {
        status: 500,
        errors: @user.errors.full_messages
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
