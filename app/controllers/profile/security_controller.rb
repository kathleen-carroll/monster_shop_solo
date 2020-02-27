class Profile::SecurityController < Profile::BaseController

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params) && @user.pw_check_not_empty(params)
      flash[:success] = 'Password updated'
      redirect_to '/profile'
    elsif @user.pw_check_empty(params)
      flash[:error] = "Password can't be blank"
      redirect_to '/profile/edit/pw'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to '/profile/edit/pw'
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
