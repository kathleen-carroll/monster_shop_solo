<<<<<<< HEAD
class Merchant::OrdersController < ApplicationController
  def show
  end
=======
class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find_by(id: params[:id])
    render file: "/public/404" if no_order
  end

  private
    def no_order
      @order.nil? || @order.item_orders.by_merchant(current_user.merchant.id).empty?
    end
>>>>>>> 531e243c69d0edecba418c08947d1a7a70cef54b
end
