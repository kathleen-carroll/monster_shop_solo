class ItemsController<ApplicationController

  def index
    @items = Item.where(active?: true)
  end

  def show
    @item = Item.find(params[:id])
    render file: "/public/404" unless viewable
  end

  private

    def viewable
      return current_admin? if !@item.active?
      true
    end
end
