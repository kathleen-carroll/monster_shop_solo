class Profile::OrdersController < Profile::BaseController
  def index
    @user = current_user
  end

  def show
    @order = Order.find(params[:id])
  end
end
