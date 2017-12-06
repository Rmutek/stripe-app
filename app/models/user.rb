class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :carted_products

  def full_name
    "#{first_name} #{last_name}"
  end

  def valid_shipping_address?
    begin
      address_to = Shippo::Address.create(
        name: full_name,
        street1: street1,
        city: city,
        state: state,
        zip: zip,
        country: 'US',
        validate: true
      )
    rescue
      p ' ******** SHIPPO API ERRROR ********* '
      return false
    end
    address_to.validation_results.is_valid
  end

  def create_stripe_customer
    shipping = {
      name: full_name,
      address: {
        line1: street1,
        line2: street2,
        city: city,
        state: state,
        postal_code: zip
      }
    }
    stripe_customer = Stripe::Customer.create(
      email: email)
    
    self.stripe_customer_id = stripe_customer.id
    save
  end

  def carted_items
    carted_products.where(status: 'carted').map { |o| { type: 'sku', parent: o.option, quantity: o.quantity } }
  end

  def address
    {
      line1: street1,
      city: city,
      country: 'US',
      postal_code: zip
    }
  end

  def self.update_cart(session_id, new_user)
    old_user = User.find_by_id(session_id) ? User.find(session_id) : User.new(id: session_id)

    if old_user.stripe_customer_id
      new_user.stripe_customer_id = old_user.stripe_customer_id
      new_user.save
    end
    
    cps = old_user.carted_products
    cps.each do |cp|
      already_carted = new_user.carted_products.find_by(
        option: cp.option,
        product_type: cp.product_type,
        status: 'carted'
      )
      if already_carted
        already_carted.quantity += cp.quantity
        already_carted.save
      else
        cp.user_id = new_user.id 
        cp.save
      end
    end
  end
end
