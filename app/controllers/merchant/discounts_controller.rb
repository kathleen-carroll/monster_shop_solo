class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = current_user.merchant.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      flash[:success] = "#{@discount.name} has been updated."
      redirect_to "/merchant/discounts/#{@discount.id}"
    else
      flash.now[:error] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def new
    merchant = current_user.merchant
    @discount = merchant.discounts.create(discount_params)
  end

  def create
    merchant = current_user.merchant
    @discount = merchant.discounts.create(discount_params)
    if @discount.save
      flash[:success] = "#{@discount.name} has been saved."
      redirect_to "/merchant/discounts"
    else
      flash.now[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params.permit(:name, :percent, :item_count)
  end
end
