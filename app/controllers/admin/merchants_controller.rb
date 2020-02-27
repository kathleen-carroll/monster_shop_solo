class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
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

  def update
    merchant = Merchant.find(params[:id])
    merchant.toggle!(:active?)
    if !merchant.active?
      merchant.items.update_all(active?: false)
      flash[:success] = "#{merchant.name} has been deactivated."
    else
      merchant.items.update_all(active?: true)
      flash[:success] = "#{merchant.name} has been activated."
    end
    redirect_to admin_merchants_path
  end
end
