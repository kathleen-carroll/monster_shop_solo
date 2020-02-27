class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = current_user.merchant.items
  end

  def new
    merchant = Merchant.find(params[:merchant_id])
    @item = merchant.items.create(item_params)
    require_merchant_employee
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    params.delete :image if params[:image].blank?
    @item = merchant.items.create(item_params)
    require_merchant_employee
    if @item.save
      flash[:success] = "#{@item.name} has been saved."
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
    require_merchant_employee
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      flash[:success] = "#{item.name} has been updated."
      redirect_to "/merchant/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def show
    @item = Item.find(params[:id])
    require_merchant_employee
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = "Item Deleted."
    redirect_to "/merchant/items"
  end

    private

    def item_params
      params.permit(:name,:description,:price,:inventory,:image)
    end

    def require_merchant_employee
      render file: "/public/404" unless current_merchant_employee_for_item?
    end
end
