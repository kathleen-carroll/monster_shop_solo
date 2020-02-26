class MerchantItemsController <ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    if current_merchant_employee? || current_admin?
      @items = @merchant.items
    else
      @items = @merchant.items.where(active?: true)
    end
  end

end
