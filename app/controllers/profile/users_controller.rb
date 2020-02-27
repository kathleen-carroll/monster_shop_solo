class Profile::UsersController < Profile::BaseController
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
      redirect_to '/profile/edit'
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
      :role,
      :password,
      :password_confirmation
    )
  end
end
