class Merchant::ItemOrdersController < Merchant::BaseController
  def update
    item_order = ItemOrder.find(params[:id])
    if item_order.unfulfilled? && item_order.fulfill
      flash[:success] = "Item has been fulfilled."
      item_order.order.ready
    else
      flash[:error] = "Cannot fulfill order."
    end
    redirect_to(merchant_order_path(item_order.order.id))
  end
end
