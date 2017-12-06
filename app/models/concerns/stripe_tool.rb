include ActionView::Helpers::NumberHelper
module StripeTool
  
  def self.product_quantity(product)
    product.skus.data[0].inventory.quantity + 1
  end

  def self.get_plan(carted_product)
    plans = Stripe::Plan.list(limit: 50)
    plan = plans.data.select{ |plan| plan.metadata.prod_id == carted_product.product_id && plan.metadata.frequency == carted_product.product_type }.first
  end

  def self.create_order(user)
    begin
      order = Stripe::Order.create(
        currency: 'usd',
        customer: user.stripe_customer_id,
        items: user.carted_items,
        shipping: {
          name: user.full_name,
          address: user.address
        }
      )
    rescue => error
      p ' ******** STRIPE API ERRROR ********* '
      return error
    end
    user.current_order_id = order.id
    user.save
    order
  end
end