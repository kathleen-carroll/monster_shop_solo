class Merchant::ToggleController < Merchant::BaseController

  def update
    item = Item.find(params[:id])
    item.toggle!(:active?)
    if item.active?
      flash[:success] = "#{item.name} is now available for sale."
    else
      flash[:error] = "#{item.name} is no longer for sale."
    end
    redirect_to "/merchant/items"
  end
end
