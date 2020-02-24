class Profile::OrdersController < Profile::BaseController
  def index
    @user = current_user
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
  end

  def create
    order = current_user.orders.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      flash[:success] = "Your order was created."
      redirect_to "/profile/orders"
    else
      flash[:error] = "Please complete address form to create an order."
      render :new
    end
  end

  def update
    order = Order.find(params[:id])

    # fulfilled = order.item_orders.where(status: :fulfilled)

    order.update(status: 3)
    order.item_orders.update(status: 'unfulfilled')

    flash[:success] = "Your order has been cancelled."
    redirect_to "/profile"
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
