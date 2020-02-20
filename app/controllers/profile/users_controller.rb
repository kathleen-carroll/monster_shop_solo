class Profile::UsersController < ApplicationController
  before_action :require_user

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = 'Profile successfully updated'
      redirect_to '/profile'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def require_user
    render file: "/public/404" if current_user.nil?
  end

  def user_params
    params.permit(
      :name,
      :address,
      :city,
      :state,
      :zip,
      :email,
      :role
    )
  end
end
