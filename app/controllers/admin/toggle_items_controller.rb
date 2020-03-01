class Admin::ToggleItemsController < Admin::BaseController

  def update
    item = Item.find(params[:id])
    merchant = item.merchant
    item.toggle!(:active?)
    if item.active?
      flash[:success] = "#{item.name} is now available for sale."
    else
      flash[:error] = "#{item.name} is no longer for sale."
    end
    redirect_to "/admin/merchants/#{merchant.id}/items"
  end
end
