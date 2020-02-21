class Profile::OrdersController < Profile::BaseController
  def index
    @orders = current_user.orders
  end
end
