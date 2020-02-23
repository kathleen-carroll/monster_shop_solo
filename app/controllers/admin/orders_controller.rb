class Admin::OrdersController < Admin::BaseController
  before_action :require_admin

  def update
    @order = Order.find(params[:id])
    if @order.update({status: 2})
      flash[:success] = 'Order Shipped'
    end
  end

  private

  def require_admin
    render file: "/public/404" unless current_admin?
  end
end
