class CartedProductsController < ApplicationController
  def create
    @carted_product = CartedProduct.find_by(
      status: 'carted',
      user_id: guest_or_current_user_id,
      option: params[:carted_product][:option],
      product_type: params[:carted_product][:product_type]
    )

    if @carted_product
      @carted_product.quantity = @carted_product.quantity.to_i + params[:carted_product][:quantity].to_i
    else
      @carted_product = CartedProduct.new(carted_product_params.merge(status: 'carted', user_id: guest_or_current_user_id))
    end

    if @carted_product.save
      flash[:alert] = 'Added to Cart!'
      redirect_to request.env["HTTP_REFERER"]
    else
      flash[:alert] = @carted_product.errors.full_messages
      render 'products/index'
    end
  end

  def index
    @carted_products = CartedProduct.where(user_id: guest_or_current_user_id, status: 'carted')

    if @carted_products.empty?
      flash[:alert] = "Cart is empty!"
      redirect_to '/'
    else
      user_id = guest_or_current_user_id

      if User.find_by_id(user_id)
        @user = User.find(user_id)
      end
      
      @valid_shipping_address = @user ? @user.valid_shipping_address? : false
    end
  end

  def destroy
    @carted_product = CartedProduct.find_by(id: params[:id])
    @carted_product.destroy
    flash[:success] = 'Product Removed'
    redirect_to '/carted_products'
  end

  private

    def carted_product_params
      params.require(:carted_product).permit(
        :product_id,
        :quantity,
        :product_type,
        :amount,
        :name,
        :status,
        :user_id,
        :option
      )
    end
end
