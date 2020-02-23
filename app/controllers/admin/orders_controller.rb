class Admin::OrdersController < Admin::BaseController

  def update
    @order = Order.find(params[:id])
    if @order.update({status: 2})
      flash[:success] = 'Order Shipped'
      redirect_to '/admin'
    end
  end
end
