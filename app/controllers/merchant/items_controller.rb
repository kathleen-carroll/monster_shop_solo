class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = current_user.merchant.items.distinct
  end

  def new
    merchant = Merchant.find(params[:merchant_id])
    @item = merchant.items.create(item_params)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    params.delete :image if params[:image].blank?
    @item = merchant.items.create(item_params)
    if @item.save
      flash[:success] = "#{@item.name} has been saved."
      redirect_to "/merchants/#{merchant.id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      flash[:success] = "#{@item.name} has been updated."
      redirect_to "/merchants/#{@item.merchant.id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = "Item Deleted."
    redirect_to "/merchants/#{item.merchant.id}/items"
  end

    private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end
end
