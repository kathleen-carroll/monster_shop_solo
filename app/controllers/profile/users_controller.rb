class Profile::UsersController < ApplicationController
  before_action :require_user

  def show
    @user = current_user
  end

  private

  def require_user
    render file: "/public/404" if current_user.nil?
  end
end
