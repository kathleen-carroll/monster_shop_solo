class SessionsController < ApplicationController

  def new
    if current_admin?
      flash[:success] = "You are already logged in as admin."
      redirect_to "/admin"
    elsif current_merchant?
      flash[:success] = "You are already logged in as merchant."
      redirect_to "/merchant"
    elsif current_user
      flash[:success] = "You are already logged in as user."
      redirect_to profile_path
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      welcome(user)
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:success] = "You are now logged out."
    redirect_to "/"
  end

  private

  def welcome(user)
    if current_admin?
      flash[:success] = "Welcome Admin #{user.name}! You are logged in."
      redirect_to "/admin"
    elsif current_merchant?
      flash[:success] = "Welcome Merchant #{user.name}! You are logged in."
      redirect_to "/merchant"
    else
      flash[:success] = "Welcome #{user.name}! You are logged in."
      redirect_to profile_path
    end
  end
end
