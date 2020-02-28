class Merchant::OrdersController < Merchant::BaseController
  before_action :require_orders, only: [:show]

  def show
  end

  private
    def require_orders
      @order = Order.find_by(id: params[:id])
      no_orders = @order.nil? || @order.item_orders.by_merchant(current_user.merchant.id).empty?
      render file: "/public/404" if no_orders
    end
end
