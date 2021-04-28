class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  helper_method :login!, :logged_in?, :current_user, :authorized_user?, :logout!, :decode, :encode

  def login!
    session[:user_id] = @user.id
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorized_user?
    @user == current_user
  end

  def logout!
    session.clear
  end

  def encode(payload)
    JWT.encode(payload, 'secret_key', 'HS256')
  end

  def decode(token)
    JWT.decode(token, 'secret_key', true, { algorithm: 'HS256' })[0]
  end
end
