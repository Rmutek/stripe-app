class Api::OrdersController < ApplicationController

  def new
    @user = User.find(guest_or_current_user_id)
    unless @user.stripe_customer_id
      @user.create_stripe_customer
    end

    @order = StripeTool.create_order(@user)

    if @order.class == Stripe::InvalidRequestError
      render json: { error: @order }, :status => 422
    else
      render json: { order: @order, user: @user }
    end
  end

  def create
    user = User.find(guest_or_current_user_id)
    order = Stripe::Order.retrieve(user.current_order_id)
    token = params[:stripeToken]

    begin
      order.pay(source: token, email: user.email)
    rescue Stripe::CardError => e
      p e.message
    rescue Stripe::StripeError => e
      p e.message
    end

    user.current_order_id = nil;
    user.save

    carted_products = CartedProduct.where(user_id: user.id, status: 'carted')
    carted_products.map do |carted_product|
      carted_product.status = 'ordered'
      carted_product.order_id = order.id
      carted_product.save
    end
    flash[:success] = 'Charge created!'
    redirect_to "/orders/#{order.id}"
  end

  def update
    @order = Stripe::Order.retrieve(params[:id])
    @order.selected_shipping_method = params[:selected_shipping_method]
    if @order.save
      render json: { order: @order }
    else
      render json: { error: 'Unable to update shipping selection' }
    end
  end
end