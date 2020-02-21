class Profile::UsersController < Profile::BaseController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    current_pw = @user.password
    if @user.update(user_params) && current_pw == @user.password
      flash[:success] = 'Profile successfully updated'
      redirect_to '/profile'
    elsif @user.update(user_params) && current_pw != @user.password
      flash[:success] = 'Password updated'
      redirect_to '/profile'
    elsif user_params[:password] != user_params[:password_confirmation]
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to '/profile/edit/pw'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to '/profile/edit'
    end
  end

  def edit_pw
    @user = current_user
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
