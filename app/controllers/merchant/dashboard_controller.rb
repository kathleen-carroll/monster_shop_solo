class Merchant::DashboardController < Merchant::BaseController

  def index
    @merchant = current_user.merchant
    @item_orders = @merchant.items
                            .joins(:orders)
                            .where("orders.status = 1")
                            .distinct
                            .group('orders.id')
                            .sum('item_orders.quantity * item_orders.price')

     @item_orders2 = @merchant.items
                             .joins(:orders)
                             .where("orders.status = 1")
                             .distinct
                             .group('orders.id')
                             .sum('item_orders.quantity')

    @orders = Order.joins(:items).distinct.where("orders.status = 1 and items.merchant_id = #{@merchant.id}")
  end
end
