class Merchant::DashboardController < ApplicationController
  before_action :require_merchant

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

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end
end
