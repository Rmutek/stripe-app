class SubscriptionsController < ApplicationController
  def create
    @user = current_user
    unless @user.stripe_customer_id
      @user.create_stripe_customer
    end

    carted_product = CartedProduct.find(params[:carted_product_id])
    plan = StripeTool.get_plan(carted_product)

    items =  [{
      plan: plan.id,
      quantity: carted_product.quantity
    }]

    begin
      subscription = Stripe::Subscription.create(
        customer: @user.stripe_customer_id,
        items: items,
        source: params[:stripeToken]
      )
    rescue Stripe::CardError => e
      p ' ******** STRIPE API ERRROR ********* '
      p e.message
    rescue Stripe::StripeError => e
      p ' ******** STRIPE API ERRROR ********* '
      p e.message
      flash[:warning] = 'Error Creating Subscription'
      redirect_to request.env["HTTP_REFERER"]
    end

    carted_product.status = 'subscribed'
    carted_product.order_id = subscription.id
    carted_product.save

    flash[:success] = 'Subscription created!'
    redirect_to "/users/#{@user.id}"
  end

  def destroy
    carted_product = CartedProduct.find(params[:id])
    subscription = Stripe::Subscription.retrieve(carted_product.order_id)
    subscription.delete
    carted_product.status = 'cancelled'
    carted_product.save
    flash[:success] = 'Subscription cancelled'
    redirect_to request.env["HTTP_REFERER"]
  end
end
