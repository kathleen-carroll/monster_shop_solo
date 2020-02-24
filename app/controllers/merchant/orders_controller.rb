class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find_by(id: params[:id])
    render file: "/public/404" if no_order
  end

  private
    def no_order
      @order.nil? || @order.item_orders.by_merchant(current_user.merchant.id).empty?
    end
end
