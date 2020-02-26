class MerchantItemsController <ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items.where(active?: true)
  end

end
