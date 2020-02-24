class Merchant::ItemOrdersController < Merchant::BaseController
  def update
    item_order = ItemOrder.find(params[:id])
    item_order.fulfill
    redirect_to(merchant_order(item_order.item.id))
  end
end
