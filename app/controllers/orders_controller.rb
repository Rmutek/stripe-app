class OrdersController < ApplicationController
  def new
    @user = User.find(guest_or_current_user_id)
  end

  def show
    @order = Stripe::Order.retrieve(params[:id])
  end
end
