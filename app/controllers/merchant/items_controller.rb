class Merchant::ItemsController < Merchant::BaseController
  before_action :require_employee, only: [:new, :create]
  before_action :require_item_match, only: [:show, :edit, :update]

  def index
    @items = Merchant.find(current_user.merchant.id).items
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
      redirect_to "/merchant/items"
    else
      flash.now[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      flash[:success] = "#{@item.name} has been updated."
      redirect_to "/merchant/items"
    else
      flash.now[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def show
  end

  def destroy
    item = Item.find_by(id: params[:id])
    if !item
      flash[:error] = "Item already deleted."
    elsif item.no_orders?
      flash[:success] = "'#{item.name}' has been deleted."
      item.destroy
    else
      flash[:error] = "Cannot delete an item with orders."
    end
    redirect_to "/merchant/items"
  end

    private

    def item_params
      params.permit(:name,:description,:price,:inventory,:image)
    end

    def require_employee
      authorized = params[:merchant_id] == current_user.merchant.id.to_s
      render file: "/public/404" unless authorized
    end

    def require_item_match
      @item = Item.find_by(id: params[:id])
      authorized = @item && @item.merchant == current_user.merchant
      render file: "/public/404" unless authorized
    end
end
