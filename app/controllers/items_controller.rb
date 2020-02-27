class ItemsController<ApplicationController

  def index
    @items = Item.where(active?: true)
  end

  def show
    @item = Item.find(params[:id])
    render file: "/public/404" unless viewable
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if @item.save
      redirect_to "/items/#{@item.id}"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/items"
  end

  private

    def item_params
      params.permit(:name,:description,:price,:inventory,:image)
    end

    def viewable
      if !@item.active?
        current_merchant_employee_for_item? || current_admin?
      else
        true
      end
    end
end
