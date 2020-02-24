class Merchant::DashboardController < Merchant::BaseController
  
  def index
    @merchant = current_user.merchant
    @item_orders = @merchant.items
                            .joins(:orders)
                            .select('item_orders.order_id,
                                     item_orders.item_id,
                                     item_orders.created_at,
                                     item_orders.quantity,
                                     item_orders.price')
  end
end
