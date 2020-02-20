class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      welcome(user)
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:success] = "You are now logged out."
    redirect_to "/"
  end

  private

  def welcome(user)
    if current_admin?
      flash[:success] = "Welcome Admin #{user.email}! You are logged in."
      redirect_to "/admin"
    elsif current_merchant?
      flash[:success] = "Welcome Merchant #{user.email}! You are logged in."
      redirect_to "/merchant"
    else
      flash[:success] = "Welcome #{user.email}! You are logged in."
      redirect_to profile_path
    end
  end
end
