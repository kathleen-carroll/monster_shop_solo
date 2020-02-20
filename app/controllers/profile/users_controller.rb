class Profile::UsersController < Profile::BaseController
  def show
    @user = current_user
  end
end
