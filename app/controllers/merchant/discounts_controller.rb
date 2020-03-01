class Merchant::DiscountsController < Merchant::BaseController
  def index
    @discounts = Discount.all
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    @discount = merchant.discounts.create(discount_params)
    if @discount.save
      flash[:success] = 'Discount created.'
      redirect_to merchant_discounts_path
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

    private

    def discount_params
      params.require(:discount).permit(
        :name,
        :item_count,
        :percent
      )
    end
end
