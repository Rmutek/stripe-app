class ProductsController < ApplicationController
  def index
    @products = Stripe::Product.list(limit: 50)
  end
end
