class Admin::UserOrdersController < Admin::BaseController
  def index
    @user = User.find(params[:id])
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
  order = Order.find(params[:id])

  if order.pending? || order.packaged?
    order.cancel
    flash[:success] = 'Order cancelled'
  else
    flash[:error] = "Unable to cancel an order that is already #{order.status}"
  end

  redirect_to admin_path
  end
end
