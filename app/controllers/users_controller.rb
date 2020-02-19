class UsersController < ApplicationController

  def new
    @new_user = User.new(user_params)
  end

  def create
    @new_user = User.new(user_params)
    if @new_user.save
      flash[:success] = "New account successfully created! You are now logged in."
      session[:user_id] = @new_user.id
      redirect_to "/profile"
    else
      error_message(@new_user)
      render :new
    end
  end

  private
    def user_params
      params.permit(:name, :password, :password_confirmation, :address, :city, :state, :zip, :email)
    end
end
