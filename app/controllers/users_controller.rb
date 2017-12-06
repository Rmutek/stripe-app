class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @orders = 
      if @user.stripe_customer_id
        Stripe::Order.list(customer: @user.stripe_customer_id)
      else
        []
      end
  end

  def confirm_address
    user_id = guest_or_current_user_id
    @product_type = params[:product]

    if User.find_by_id(user_id)
      @user = User.find(user_id)
    else
      @user = User.new
    end
  end

  def update_address
    user_id = guest_or_current_user_id

    if User.find_by_id(user_id)
      @user = User.find(user_id)
      @user.update(user_params)
    else
      @user = User.new(user_params.merge(id: user_id, email: user_id))
    end
    
    if @user.save(validate: false)
      if @user.valid_shipping_address?
        flash[:alert] = 'Confirmed Shipping Address'
        if params[:product_type] == 'order'
          redirect_to '/orders/new'
        else
          redirect_to '/carted_products'
        end 
      else
        flash[:alert] = 'Unable to Confirm Shipping Address'
        render :confirm_address
      end
    else
      flash[:alert] = @user.errors.full_messages
      render :confirm_address
    end
  end

  private

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :street1,
        :street2,
        :state,
        :city,
        :zip,
      )
    end
end
